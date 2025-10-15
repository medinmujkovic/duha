import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../main_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScreen()),
            );
          }
          if (state is PasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password reset email sent!")),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
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
                            horizontal: 40, vertical: 48),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          // <-- removed 'bloc: context.read<AuthBloc>()'
                          builder: (context, state) {
                            final bloc = context.read<AuthBloc>();
                            final strength = state.passwordStrength ?? 0;

                            return Form(
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
                                  const Text(
                                    'Duha',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start Your Morning With Clarity',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Toggle buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              bloc.add(ToggleAuthMode()),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: state.isLogin
                                                ? const Color(0xFF7C3AED)
                                                : Colors.grey[200],
                                            foregroundColor: state.isLogin
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          child: const Text('Login'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              bloc.add(ToggleAuthMode()),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: !state.isLogin
                                                ? const Color(0xFF7C3AED)
                                                : Colors.grey[200],
                                            foregroundColor: !state.isLogin
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          child: const Text('Register'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Name field for registration
                                  if (!state.isLogin) ...[
                                    TextFormField(
                                      onChanged: (v) =>
                                          bloc.add(AuthNameChanged(v)),
                                      decoration: InputDecoration(
                                        labelText: 'Full Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        prefixIcon: const Icon(Icons.person),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Email field
                                  TextFormField(
                                    onChanged: (v) =>
                                        bloc.add(AuthEmailChanged(v)),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(Icons.email),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Password field
                                  TextFormField(
                                    onChanged: (v) =>
                                        bloc.add(AuthPasswordChanged(v)),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(Icons.lock),
                                    ),
                                  ),

                                  // Password strength
                                  if (state.password.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 12),
                                      child: LinearProgressIndicator(
                                        value: (strength / 4).clamp(0, 1),
                                        color: [
                                          Colors.red,
                                          Colors.orange,
                                          Colors.yellow,
                                          Colors.green
                                        ][strength.clamp(0, 3)],
                                        backgroundColor: Colors.grey[300],
                                        minHeight: 6,
                                      ),
                                    ),

                                  // Error message
                                  if (state.errorMessage != null)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        state.errorMessage!,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ),

                                  // Submit button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: state.isSubmitting
                                          ? null
                                          : () => bloc.add(SubmitAuthForm()),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF7C3AED),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: state.isSubmitting
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : Text(
                                              state.isLogin
                                                  ? 'Sign In'
                                                  : 'Create Account',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                    ),
                                  ),

                                  // Forgot password button
                                  ElevatedButton(
                                    onPressed: () {
                                      bloc.add(ForgotPassword());
                                    },
                                    child: const Text("Send Reset Email"),
                                  ),

                                  // Info message
                                  if (state.infoMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        state.infoMessage!,
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 14),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
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
