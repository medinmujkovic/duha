import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/screens/auth_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DuhaApp(),
    ),
  );
}

class DuhaApp extends StatelessWidget {
  const DuhaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duha App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: AuthScreen(), 
    );
  }
}
