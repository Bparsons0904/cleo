// lib/core/providers/websocket_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../di/providers_module.dart';
import '../services/websocket_service.dart';
import '../../features/auth/data/providers/auth_providers.dart';

part 'websocket_providers.g.dart';

/// WebSocket connection state
enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  authenticated,
  error,
}

/// Data class for WebSocket state
class WebSocketStateData {
  final WebSocketConnectionState state;
  final String? error;
  final Map<String, dynamic>? lastMessage;

  const WebSocketStateData({
    required this.state,
    this.error,
    this.lastMessage,
  });

  WebSocketStateData copyWith({
    WebSocketConnectionState? state,
    String? error,
    Map<String, dynamic>? lastMessage,
  }) {
    return WebSocketStateData(
      state: state ?? this.state,
      error: error ?? this.error,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}

/// Provider for WebSocket connection state
@Riverpod(keepAlive: true)
class WebSocketState extends _$WebSocketState {
  @override
  WebSocketStateData build() {
    // Listen to auth state changes
    ref.listen(isAuthenticatedProvider, (previous, next) {
      if (next) {
        // User authenticated, connect WebSocket
        _connect();
      } else {
        // User logged out, disconnect WebSocket
        _disconnect();
      }
    });

    // Auto-connect if already authenticated
    final isAuth = ref.read(isAuthenticatedProvider);
    if (isAuth) {
      Future.microtask(() => _connect());
    }

    return const WebSocketStateData(
      state: WebSocketConnectionState.disconnected,
    );
  }

  /// Connect to WebSocket
  Future<void> _connect() async {
    try {
      state = const WebSocketStateData(
        state: WebSocketConnectionState.connecting,
      );

      final wsService = ref.read(webSocketServiceProvider);
      await wsService.connect();

      // Listen to connection state changes
      wsService.stateStream.listen((wsState) {
        switch (wsState) {
          case WebSocketState.disconnected:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.disconnected,
            );
            break;
          case WebSocketState.connecting:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.connecting,
            );
            break;
          case WebSocketState.authenticating:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.connecting,
            );
            break;
          case WebSocketState.connected:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.authenticated,
            );
            break;
          case WebSocketState.error:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.error,
            );
            break;
        }
      });

      // Listen to messages
      wsService.messages.listen((message) {
        if (state.state == WebSocketConnectionState.authenticated) {
          state = state.copyWith(lastMessage: message.toJson());
          _handleMessage(message);
        }
      });

      print('✅ WebSocket connected');
    } catch (e) {
      print('⚠️ WebSocket connection error: $e');
      state = WebSocketStateData(
        state: WebSocketConnectionState.error,
        error: e.toString(),
      );
    }
  }

  /// Disconnect from WebSocket
  void _disconnect() {
    try {
      final wsService = ref.read(webSocketServiceProvider);
      wsService.disconnect();

      state = const WebSocketStateData(
        state: WebSocketConnectionState.disconnected,
      );

      print('✅ WebSocket disconnected');
    } catch (e) {
      print('⚠️ WebSocket disconnect error: $e');
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(WebSocketMessage message) {
    final type = message.type;
    final data = message.dataAsMap;

    print('📨 WebSocket message: $type');

    switch (type) {
      case 'SYNC_PROGRESS':
        // Update sync progress
        if (data.isNotEmpty) {
          final progress = data['progress'] as int?;
          final total = data['total'] as int?;
          print('📊 Sync progress: $progress / $total');
        }
        break;

      case 'SYNC_COMPLETE':
        // Sync completed, refresh user data
        print('✅ Sync complete, refreshing user data...');
        // TODO: Refresh user data provider
        break;

      case 'API_PROGRESS':
        // API operation progress
        if (data.isNotEmpty) {
          final progress = data['progress'] as int?;
          final total = data['total'] as int?;
          print('📊 API progress: $progress / $total');
        }
        break;

      case 'API_COMPLETE':
        // API operation completed
        print('✅ API operation complete');
        break;

      case 'API_ERROR':
        // Handle error message
        final errorMsg = data['message'] as String?;
        print('❌ WebSocket error: $errorMsg');
        state = state.copyWith(error: errorMsg);
        break;

      default:
        print('ℹ️ Unknown WebSocket message type: $type');
    }
  }

  /// Send a message through WebSocket
  void sendMessage({
    required String type,
    Map<String, dynamic>? data,
  }) {
    try {
      final wsService = ref.read(webSocketServiceProvider);
      wsService.sendMessage(
        type: type,
        data: data,
      );
    } catch (e) {
      print('⚠️ Error sending WebSocket message: $e');
    }
  }

  /// Manually reconnect
  Future<void> reconnect() async {
    _disconnect();
    await _connect();
  }
}

/// Provider for checking if WebSocket is connected
@riverpod
bool isWebSocketConnected(IsWebSocketConnectedRef ref) {
  final wsState = ref.watch(webSocketStateProvider);
  return wsState.state == WebSocketConnectionState.authenticated;
}

/// Provider for WebSocket connection state
@riverpod
WebSocketConnectionState webSocketConnectionState(
  WebSocketConnectionStateRef ref,
) {
  final wsState = ref.watch(webSocketStateProvider);
  return wsState.state;
}

/// Provider for WebSocket error
@riverpod
String? webSocketError(WebSocketErrorRef ref) {
  final wsState = ref.watch(webSocketStateProvider);
  return wsState.error;
}

/// Provider for last WebSocket message
@riverpod
Map<String, dynamic>? lastWebSocketMessage(LastWebSocketMessageRef ref) {
  final wsState = ref.watch(webSocketStateProvider);
  return wsState.lastMessage;
}
