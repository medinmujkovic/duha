import 'package:duha_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/auth_state.dart';

class AuthToggleButtons extends ConsumerWidget {
  final AuthState authState;
  const AuthToggleButtons({super.key, required this.authState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (!authState.isLogin) {
                ref.read(authProvider.notifier).toggleAuthMode();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: authState.isLogin ? const Color(0xFF7C3AED) : Colors.grey[200],
              foregroundColor: authState.isLogin ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Login'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: authState.isLogin
                ? () => ref.read(authProvider.notifier).toggleAuthMode()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: !authState.isLogin ? const Color(0xFF7C3AED) : Colors.grey[200],
              foregroundColor: !authState.isLogin ? Colors.white : Colors.black,
              disabledBackgroundColor: const Color(0xFF7C3AED),
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Register'),
          ),
        ),
      ],
    );
  }
}
