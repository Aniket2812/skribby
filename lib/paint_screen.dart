import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreen extends StatefulWidget {
  final Map data;
  final String screenFrom;
  PaintScreen({required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {

  late IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    connect();
  }

  //socket.io client connection
  void connect() {
    _socket = IO.io('http://192.168.0.104:3000', <String, dynamic> {
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket.connect();

    if(widget.screenFrom == 'createRoom') {
      _socket.emit('create-game', widget.data);
    }

    //listen to socket
    _socket.onConnect((data) {
      print('connected');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}