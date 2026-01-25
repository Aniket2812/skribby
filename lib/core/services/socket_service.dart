import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:skribby/core/utils/constants.dart';

/// Singleton service for managing socket.io connections
class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;

  /// Get the current socket instance
  IO.Socket? get socket => _socket;

  /// Check if socket is connected
  bool get isConnected => _socket?.connected ?? false;

  /// Connect to the socket server
  void connect() {
    if (_socket != null && _socket!.connected) {
      return;
    }

    _socket = IO.io(AppConstants.serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('SocketService: Connected to server');
    });

    _socket!.onDisconnect((_) {
      print('SocketService: Disconnected from server');
    });

    _socket!.onError((error) {
      print('SocketService: Error - $error');
    });
  }

  /// Disconnect from the socket server
  void disconnect() {
    _socket?.disconnect();
  }

  /// Emit an event with data
  void emit(String event, [dynamic data]) {
    _socket?.emit(event, data);
  }

  /// Listen to an event
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  /// Remove a specific event listener
  void off(String event) {
    _socket?.off(event);
  }

  /// Dispose of the socket connection
  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
