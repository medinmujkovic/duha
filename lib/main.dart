import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Ensures Flutter engine is initialized before async code
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const AuthScreen(), 
    );
  }
}
