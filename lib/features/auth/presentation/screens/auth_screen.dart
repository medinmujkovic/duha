import 'package:duha_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:duha_app/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/auth_passwordstrengthindicator_utils.dart';
import '../../../../main_screen.dart';

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
    // Watch the auth state using generated provider
    final authState = ref.watch(authProvider);

    // Listen for state changes (success, errors, info messages)
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Navigate on successful login/register
      if (next.isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
        // Reset success state after navigation
        Future.microtask(() => ref.read(authProvider.notifier).resetSuccess());
      }

      // Show error message
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Clear error message after showing
        Future.microtask(() => ref.read(authProvider.notifier).clearMessages());
      }

      // Show info message (password reset confirmation)
      if (next.infoMessage != null && next.infoMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.infoMessage!),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Clear info message after showing
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 48,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          SvgPicture.asset(
                            'assets/img/logo.svg',
                            height: 100,
                            width: 100,
                          ),
                          const SizedBox(height: 16),

                          // App title
                          const Text(
                            'Duha',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'Start Your Morning With Clarity',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Toggle buttons (Login/Register)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: authState.isLogin
                                      ? null
                                      : () => ref.read(authProvider.notifier).toggleAuthMode(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: authState.isLogin
                                        ? const Color(0xFF7C3AED)
                                        : Colors.grey[200],
                                    foregroundColor: authState.isLogin
                                        ? Colors.white
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
                                    backgroundColor: !authState.isLogin
                                        ? const Color(0xFF7C3AED)
                                        : Colors.grey[200],
                                    foregroundColor: !authState.isLogin
                                        ? Colors.white
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Register'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Name field (registration only)
                          if (!authState.isLogin) ...[
                            TextFormField(
                              controller: _nameController,
                              onChanged: (value) => 
                                  ref.read(authProvider.notifier).updateName(value),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Full Name';
                                }
                                if (value.trim().length < 3) {
                                  return 'Name must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            onChanged: (value) => 
                                ref.read(authProvider.notifier).updateEmail(value),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!Auth.isValidEmail(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            onChanged: (value) => 
                                ref.read(authProvider.notifier).updatePassword(value),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (!Auth.isPasswordValid(value)) {
                                return 'Password must be 8+ chars with uppercase, lowercase, number & symbol';
                              }
                              return null;
                            },
                          ),

                          // Password strength indicator
                          PasswordStrengthIndicator(password: authState.password),

                          const SizedBox(height: 15),

                          // Error message (inline display)
                          if (authState.errorMessage != null &&
                              authState.errorMessage!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red[700], size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authState.errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Submit button (Login/Register)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authState.isSubmitting
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        ref.read(authProvider.notifier).submitForm();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: authState.isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      authState.isLogin ? 'Sign In' : 'Create Account',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Forgot password button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: authState.isSubmitting
                                  ? null
                                  : () {
                                      // Validate email before sending reset
                                      if (_emailController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Enter your email first'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      if (!Auth.isValidEmail(_emailController.text)) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Enter a valid email'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      ref.read(authProvider.notifier).forgotPassword();
                                    },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF7C3AED),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(color: Color(0xFF7C3AED)),
                              ),
                              child: const Text(
                                "Send Password Reset Email",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          // Info message (inline display)
                          if (authState.infoMessage != null &&
                              authState.infoMessage!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: Colors.green[700], size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authState.infoMessage!,
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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