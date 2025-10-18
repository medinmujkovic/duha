import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_state.dart';

// This will generate: auth_notifier.g.dart
part 'auth_notifier.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthState();
  }

  // Toggle between login and register mode
  void toggleAuthMode() {
    state = state.copyWith(
      isLogin: !state.isLogin,
      errorMessage: null,
      infoMessage: null,
    );
  }

  // Update email field
  void updateEmail(String email) {
    state = _validate(state.copyWith(
      email: email,
      errorMessage: null,
      infoMessage: null,
    ));
  }

  // Update password field
  void updatePassword(String password) {
    state = _validate(state.copyWith(
      password: password,
      errorMessage: null,
      infoMessage: null,
    ));
  }

  // Update name field
  void updateName(String name) {
    state = _validate(state.copyWith(
      name: name,
      errorMessage: null,
      infoMessage: null,
    ));
  }

  // Send password reset email
  Future<void> forgotPassword() async {
    if (!isValidEmail(state.email)) {
      state = state.copyWith(
        errorMessage: 'Enter a valid email to reset password.',
      );
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      infoMessage: null,
    );

    try {
      // Simulate email sending (replace with actual API call)
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Call your actual password reset service
      // await ref.read(authRepositoryProvider).sendPasswordReset(state.email);

      state = state.copyWith(
        isSubmitting: false,
        infoMessage: 'Password reset link sent to ${state.email}',
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to send reset email. Please try again.',
      );
    }
  }

  // Submit login/register form
  Future<void> submitForm() async {
    // Validate all fields first
    final validatedState = _validate(state);
    if (!validatedState.isValid) {
      state = validatedState.copyWith(
        errorMessage: 'Please validate all fields correctly',
        infoMessage: null,
      );
      return;
    }

    state = validatedState.copyWith(
      isSubmitting: true,
      errorMessage: null,
      infoMessage: null,
    );

    try {
      // Simulate login/register API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Replace with actual authentication logic
      // final authRepo = ref.read(authRepositoryProvider);
      // if (state.isLogin) {
      //   await authRepo.login(state.email, state.password);
      // } else {
      //   await authRepo.register(state.name, state.email, state.password);
      // }

      state = validatedState.copyWith(
        isSubmitting: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Authentication failed. Please try again.',
      );
    }
  }

  // Clear error and info messages
  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      infoMessage: null,
    );
  }

  // Reset success state (after navigation)
  void resetSuccess() {
    state = state.copyWith(isSuccess: false);
  }

  // Validation logic
  AuthState _validate(AuthState s) {
    final validEmail = isValidEmail(s.email);
    final validName = s.isLogin ? true : s.name.trim().length >= 3;
    final passwordStrength = _passwordStrength(s.password);
    final validPassword = passwordStrength >= 3;

    final valid = validEmail && validName && validPassword;
    return s.copyWith(
      isValid: valid,
      passwordStrength: passwordStrength,
    );
  }

  // Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  // Password validation (strong password requirements)
  static bool isPasswordValid(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  // Calculate password strength (0-4)
  static int _passwordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) score++;
    return score;
  }
   Future<void> logout() async {
    // Reset all fields
    state = const AuthState(
      isLogin: true,       // go back to login mode
      email: '',
      password: '',
      name: '',
      errorMessage: null,
      infoMessage: 'Logged out successfully',
      isSubmitting: false,
      isValid: false,
      passwordStrength: 0,
      isSuccess: false,
    );
    
  }
}

// Optional: Convenience providers for specific state properties
@riverpod
bool isLoginMode(IsLoginModeRef ref) {
  return ref.watch(authProvider).isLogin;
}

@riverpod
bool isFormValid(IsFormValidRef ref) {
  return ref.watch(authProvider).isValid;
}

@riverpod
bool isSubmitting(IsSubmittingRef ref) {
  return ref.watch(authProvider).isSubmitting;
}

@riverpod
int passwordStrength(PasswordStrengthRef ref) {
  return ref.watch(authProvider).passwordStrength;
}
