import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skribby/core/services/socket_service.dart';
import 'package:skribby/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<SocketService>(
      create: (_) => SocketService(),
      child: MaterialApp(
        title: 'Skribby',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeView(),
      ),
    );
  }
}
