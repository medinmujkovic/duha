// ignore_for_file: use_build_context_synchronously
import 'package:duha_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:duha_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignOutButton extends ConsumerWidget {
  final bool isIconOnly;

  const SignOutButton({super.key, this.isIconOnly = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isIconOnly) {
      // For AppBar IconButton
      return IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () => _signOut(context, ref),
      );
    }

    // Full ElevatedButton
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout),
      label: const Text('Sign Out'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
      ),
      onPressed: () => _signOut(context, ref),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).logout();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed out successfully'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }
}
