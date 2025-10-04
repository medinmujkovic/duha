import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/login_screen.dart';
import 'features/groups/groups_screen.dart';


GoRouter buildRouter(dynamic ref) => GoRouter(
routes: [
GoRoute(path: '/', builder: (_, __) => const AuthGate()),
GoRoute(path: '/groups', builder: (_, __) => const GroupsScreen()),
],
);


class AuthGate extends StatelessWidget {
const AuthGate({super.key});
@override
Widget build(BuildContext context) {
return StreamBuilder<User?>(
stream: FirebaseAuth.instance.authStateChanges(),
builder: (context, snap) {
if (snap.connectionState != ConnectionState.active) {
return const Scaffold(body: Center(child: CircularProgressIndicator()));
}
final user = snap.data;
if (user == null) return const LoginScreen();
return const GroupsScreen();
},
);
}
}