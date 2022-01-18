import 'package:band/services/sockect_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sockectService = Provider.of<SocketService>(context);
    // sockectService.socket.emit(event)
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          final mensaje = Map<String, String>();
          mensaje['nombre'] = 'Hairo Flutter';
          mensaje['mensaje'] = 'Hola Anita hermosa!!!!!';
          sockectService.emit('emitir-mensaje', mensaje);
          // sockectService.socket.on('emitir-mensaje', (mensaje) {
          //   {
          //   }
          // });
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('ServerStatus: ${sockectService.serverStatus}')],
        ),
      ),
    );
  }
}
