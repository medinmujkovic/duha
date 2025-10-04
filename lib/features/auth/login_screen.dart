import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});
@override
State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
final email = TextEditingController();
final pass = TextEditingController();
bool loading = false;


Future<void> login() async {
setState(() => loading = true);
try {
await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text);
} on FirebaseAuthException catch (e) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Login error')));
} finally { setState(() => loading = false); }
}


Future<void> register() async {
setState(() => loading = true);
try {
await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: pass.text);
} on FirebaseAuthException catch (e) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Register error')));
} finally { setState(() => loading = false); }
}


@override
Widget build(BuildContext context) {
return Scaffold(
body: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 420),
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Text('Goal Tracker', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
const SizedBox(height: 24),
TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
const SizedBox(height: 12),
TextField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
const SizedBox(height: 24),
FilledButton(onPressed: loading? null : login, child: const Text('Login')),
const SizedBox(height: 8),
OutlinedButton(onPressed: loading? null : register, child: const Text('Register')),
],
),
),
),
),
);
}
}