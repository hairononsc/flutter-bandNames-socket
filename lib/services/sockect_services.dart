import 'package:flutter/material.dart';

// external package
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // 'http://192.168.0.105:3000/
    this._socket = IO.io('http://192.168.0.101:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('nombre: ${payload['nombre']}');
    //   print('mensaje: ${payload['mensaje']}');
    //   print('mensaje: ${payload.containsKey('mensaje2')?payload['mensaje2']:"No hay"}');

    //   // this._serverStatus = ServerStatus.Offline;
    //   // notifyListeners();
    // });

// add this line
    // socket.connect();
  }
}
