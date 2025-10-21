import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';

class AuthSubmitButtons extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final AuthState authState;

  const AuthSubmitButtons({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.authState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for success state changes
      ref.listen<AuthState>(authProvider, (previous, next) {
        if (next.isSuccess) {
          if (!next.isLogin) {
          ref.read(authProvider.notifier).toggleAuthMode(); 
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.isLogin
                ? 'Logged in successfully!'
                : 'Account created successfully! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Reset success state to prevent multiple snackbars
        Future.microtask(() => ref.read(authProvider.notifier).resetSuccess());
      }

      // Optionally handle error messages here too
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );

        Future.microtask(() => ref.read(authProvider.notifier).clearMessages());
      }
    });

    return Column(
      children: [
        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authState.isSubmitting
                ? null
                : () {
                    if (formKey.currentState!.validate()) {
                      ref.read(authProvider.notifier).submitForm();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: authState.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    authState.isLogin ? 'Sign In' : 'Create Account',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: 10),

        // Password reset button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: authState.isSubmitting
                ? null
                : () {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Enter your email first'),
                            backgroundColor: Colors.orange),
                      );
                      return;
                    }
                    if (!Auth.isValidEmail(emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Enter a valid email'),
                            backgroundColor: Colors.orange),
                      );
                      return;
                    }
                    ref.read(authProvider.notifier).forgotPassword();
                  },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              side: const BorderSide(color: Color(0xFF7C3AED)),
            ),
            child: const Text("Send Password Reset Email",
                style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
