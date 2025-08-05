import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'config.dart';

class SocketService {

  static final SocketService _instance = SocketService._internal();
  IO.Socket? socket;

  SocketService._internal();

  factory SocketService() {
    return _instance;
  }


  IO.Socket getSocketInstance() {
    if (socket == null) {
      socket = IO.io(Config.socketUrl, <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
      });

      socket!.on('connect', (_) {
        print('Socket connected');
      });

      socket!.on('disconnect', (_) {
        print('Socket disconnected');
      });

      socket!.on('connect_error', (error) {
        print('Connection Error: $error');
      });

      socket!.on('reconnect_attempt', (_) {
        print('Attempting to reconnect...');
      });
    }
    return socket!;
  }


  void connect() {
    if (socket != null && !socket!.connected) {
      socket!.connect();
    }
  }

  void disconnect() {
    socket?.disconnect();
  }
}
