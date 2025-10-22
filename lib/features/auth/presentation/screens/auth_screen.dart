import 'package:duha_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:duha_app/features/auth/presentation/widgets/auth_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/auth_state.dart';
import '../../../../main_screen.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_toggle_buttons.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_submit_buttons.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listeners for auth state (success, error, info)
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
        Future.microtask(() => ref.read(authProvider.notifier).resetSuccess());
      }
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
        Future.microtask(() => ref.read(authProvider.notifier).clearMessages());
      }
      if (next.infoMessage != null && next.infoMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.infoMessage!), backgroundColor: Colors.green),
        );
        Future.microtask(() => ref.read(authProvider.notifier).clearMessages());
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7C3AED),
              Color(0xFF2563EB),
              Color(0xFF4F46E5),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AuthLogo(),
                          const SizedBox(height: 32),
                          AuthToggleButtons(authState: authState),
                          const SizedBox(height: 24),
                          AuthFormFields(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            nameController: _nameController,
                            authState: authState,
                          ),
                          const SizedBox(height: 15),
                          AuthMessages(authState: authState),
                          const SizedBox(height: 10),
                          AuthSubmitButtons(
                            formKey: _formKey,
                            emailController: _emailController,
                            authState: authState,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
