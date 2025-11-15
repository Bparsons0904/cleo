import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';
import '../config/environment.dart';
import 'auth_service.dart';

/// WebSocket message model
class WebSocketMessage {
  final String id;
  final String service;
  final String event;
  final String? userId;
  final Map<String, dynamic> payload;
  final DateTime timestamp;

  WebSocketMessage({
    required this.id,
    required this.service,
    required this.event,
    this.userId,
    required this.payload,
    required this.timestamp,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      id: json['id'] ?? '',
      service: json['service'] ?? 'unknown',
      event: json['event'] ?? 'unknown',
      userId: json['userId'],
      payload: json['payload'] ?? {},
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service,
      'event': event,
      if (userId != null) 'userId': userId,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// WebSocket connection state
enum WebSocketState {
  disconnected,
  connecting,
  authenticating,
  connected,
  error,
}

/// WebSocket service for real-time communication with Waugzee backend
/// Handles authentication, ping/pong, and message routing
class WebSocketService {
  final AuthService _authService;
  final Logger _logger = Logger();

  WebSocketChannel? _channel;
  StreamSubscription? _messageSubscription;
  Timer? _pingTimer;
  Timer? _authTimeoutTimer;

  WebSocketState _state = WebSocketState.disconnected;
  WebSocketState get state => _state;

  // Event streams for different message types
  final _messageController = StreamController<WebSocketMessage>.broadcast();
  final _stateController = StreamController<WebSocketState>.broadcast();

  Stream<WebSocketMessage> get messages => _messageController.stream;
  Stream<WebSocketState> get stateStream => _stateController.stream;

  WebSocketService(this._authService);

  /// Connect to WebSocket server
  Future<void> connect() async {
    if (_state == WebSocketState.connected || _state == WebSocketState.connecting) {
      _logger.w('⚠️ Already connected or connecting');
      return;
    }

    try {
      _setState(WebSocketState.connecting);
      _logger.i('🔌 Connecting to WebSocket: ${EnvironmentConfig().wsUrl}');

      _channel = WebSocketChannel.connect(
        Uri.parse(EnvironmentConfig().wsUrl),
      );

      _setState(WebSocketState.authenticating);

      // Listen to messages
      _messageSubscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      // Start auth timeout (10 seconds)
      _authTimeoutTimer = Timer(const Duration(seconds: 10), () {
        if (_state == WebSocketState.authenticating) {
          _logger.e('❌ Authentication timeout');
          disconnect();
        }
      });

      _logger.i('✅ WebSocket connected, waiting for auth request');
    } catch (e, stackTrace) {
      _logger.e('❌ WebSocket connection error', error: e, stackTrace: stackTrace);
      _setState(WebSocketState.error);
      _handleReconnect();
    }
  }

  /// Handle incoming messages
  void _handleMessage(dynamic data) {
    try {
      final json = jsonDecode(data);
      final message = WebSocketMessage.fromJson(json);

      _logger.d('📨 Received: ${message.event} from ${message.service}');

      // Handle system messages
      if (message.service == 'system') {
        _handleSystemMessage(message);
      } else {
        // Broadcast to listeners
        _messageController.add(message);
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Error parsing message', error: e, stackTrace: stackTrace);
    }
  }

  /// Handle system messages (auth, ping/pong)
  void _handleSystemMessage(WebSocketMessage message) {
    switch (message.event) {
      case 'auth_request':
        _handleAuthRequest();
        break;

      case 'auth_success':
        _handleAuthSuccess(message);
        break;

      case 'auth_failure':
        _handleAuthFailure(message);
        break;

      case 'ping':
        _handlePing(message);
        break;

      case 'pong':
        _logger.d('🏓 Received pong');
        break;

      default:
        _logger.d('📨 System message: ${message.event}');
        _messageController.add(message);
    }
  }

  /// Handle authentication request from server
  Future<void> _handleAuthRequest() async {
    try {
      _logger.i('🔐 Received auth request');

      final token = await _authService.getValidAccessToken();

      if (token == null) {
        _logger.e('❌ No valid token available');
        disconnect();
        return;
      }

      // Send auth response
      final authMessage = {
        'event': 'auth_response',
        'payload': {
          'token': token,
        },
      };

      _send(authMessage);
      _logger.i('🔑 Sent auth response');
    } catch (e, stackTrace) {
      _logger.e('❌ Error handling auth request', error: e, stackTrace: stackTrace);
      disconnect();
    }
  }

  /// Handle successful authentication
  void _handleAuthSuccess(WebSocketMessage message) {
    _logger.i('✅ WebSocket authenticated');
    _authTimeoutTimer?.cancel();
    _setState(WebSocketState.connected);

    // Start ping/pong keep-alive
    _startPingTimer();
  }

  /// Handle authentication failure
  void _handleAuthFailure(WebSocketMessage message) {
    _logger.e('❌ WebSocket authentication failed');
    _authTimeoutTimer?.cancel();
    disconnect();
  }

  /// Handle ping from server
  void _handlePing(WebSocketMessage message) {
    _logger.d('🏓 Received ping');

    // Send pong response
    final pongMessage = {
      'event': 'pong',
      'payload': {},
    };

    _send(pongMessage);
  }

  /// Start ping timer (every 30 seconds)
  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_state == WebSocketState.connected) {
        _logger.d('🏓 Sending ping');
        _send({
          'event': 'ping',
          'payload': {},
        });
      }
    });
  }

  /// Send a message through WebSocket
  void _send(Map<String, dynamic> data) {
    if (_channel == null) {
      _logger.w('⚠️ Cannot send message - not connected');
      return;
    }

    try {
      final json = jsonEncode(data);
      _channel!.sink.add(json);
      _logger.d('📤 Sent: ${data['event']}');
    } catch (e, stackTrace) {
      _logger.e('❌ Error sending message', error: e, stackTrace: stackTrace);
    }
  }

  /// Send a custom message
  void sendMessage({
    required String event,
    Map<String, dynamic>? payload,
  }) {
    _send({
      'event': event,
      'payload': payload ?? {},
    });
  }

  /// Handle WebSocket errors
  void _handleError(error) {
    _logger.e('❌ WebSocket error: $error');
    _setState(WebSocketState.error);
    _handleReconnect();
  }

  /// Handle WebSocket disconnect
  void _handleDisconnect() {
    _logger.w('🔌 WebSocket disconnected');
    _setState(WebSocketState.disconnected);
    _cleanup();
    _handleReconnect();
  }

  /// Attempt reconnection
  void _handleReconnect() {
    _logger.i('🔄 Attempting to reconnect in 5 seconds...');

    Timer(const Duration(seconds: 5), () {
      if (_state == WebSocketState.disconnected || _state == WebSocketState.error) {
        connect();
      }
    });
  }

  /// Disconnect WebSocket
  void disconnect() {
    _logger.i('🔌 Disconnecting WebSocket');
    _cleanup();
    _channel?.sink.close();
    _channel = null;
    _setState(WebSocketState.disconnected);
  }

  /// Clean up resources
  void _cleanup() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
    _pingTimer?.cancel();
    _pingTimer = null;
    _authTimeoutTimer?.cancel();
    _authTimeoutTimer = null;
  }

  /// Update state and notify listeners
  void _setState(WebSocketState newState) {
    if (_state != newState) {
      _state = newState;
      _stateController.add(newState);
      _logger.d('📊 State changed: $newState');
    }
  }

  /// Dispose service
  void dispose() {
    disconnect();
    _messageController.close();
    _stateController.close();
  }
}
