import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ukl_frontend25/view/loginview.dart';
import 'package:ukl_frontend25/view/playlistview.dart';
import 'package:ukl_frontend25/view/playlistdetailview.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginView(), 
        '/playlist': (context) => const PlaylistView(), 
        '/playlist-detail': (context) => const PlaylistDetailView(), 
      },
    );
  }
}