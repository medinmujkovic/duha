import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(DuhaApp());
}

class DuhaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duha App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
