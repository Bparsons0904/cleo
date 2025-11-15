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
      wsService.connectionState.listen((wsState) {
        switch (wsState) {
          case ConnectionState.disconnected:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.disconnected,
            );
            break;
          case ConnectionState.connecting:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.connecting,
            );
            break;
          case ConnectionState.connected:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.connected,
            );
            break;
          case ConnectionState.authenticated:
            state = const WebSocketStateData(
              state: WebSocketConnectionState.authenticated,
            );
            break;
        }
      });

      // Listen to messages
      wsService.messages.listen((message) {
        if (state.state == WebSocketConnectionState.authenticated) {
          state = state.copyWith(lastMessage: message);
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
  Future<void> _disconnect() async {
    try {
      final wsService = ref.read(webSocketServiceProvider);
      await wsService.disconnect();

      state = const WebSocketStateData(
        state: WebSocketConnectionState.disconnected,
      );

      print('✅ WebSocket disconnected');
    } catch (e) {
      print('⚠️ WebSocket disconnect error: $e');
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(Map<String, dynamic> message) {
    final event = message['event'] as String?;
    final payload = message['payload'] as Map<String, dynamic>?;

    print('📨 WebSocket message: $event');

    switch (event) {
      case 'collection_updated':
        // Refresh user data when collection is updated
        print('🔄 Collection updated, refreshing user data...');
        // TODO: Refresh user data provider
        break;

      case 'play_added':
        // Refresh play history
        print('🔄 Play added, refreshing play history...');
        // TODO: Refresh play history provider
        break;

      case 'recommendation_ready':
        // Refresh daily recommendation
        print('🔄 Recommendation ready, refreshing...');
        // TODO: Refresh recommendation provider
        break;

      case 'sync_progress':
        // Update sync progress
        if (payload != null) {
          final progress = payload['progress'] as int?;
          final total = payload['total'] as int?;
          print('📊 Sync progress: $progress / $total');
        }
        break;

      case 'sync_complete':
        // Sync completed, refresh user data
        print('✅ Sync complete, refreshing user data...');
        // TODO: Refresh user data provider
        break;

      case 'error':
        // Handle error message
        final errorMsg = payload?['message'] as String?;
        print('❌ WebSocket error: $errorMsg');
        state = state.copyWith(error: errorMsg);
        break;

      default:
        print('ℹ️ Unknown WebSocket event: $event');
    }
  }

  /// Send a message through WebSocket
  Future<void> sendMessage(Map<String, dynamic> message) async {
    try {
      final wsService = ref.read(webSocketServiceProvider);
      wsService.send(message);
    } catch (e) {
      print('⚠️ Error sending WebSocket message: $e');
    }
  }

  /// Manually reconnect
  Future<void> reconnect() async {
    await _disconnect();
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
