import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/common/data_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../states/auth_state.dart';

part 'auth_provider.g.dart';

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
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Firebase Auth
      // await FirebaseAuth.instance.sendPasswordResetEmail(
      //   email: state.email,
      // );

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
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Firebase Authentication
      // if (state.isLogin) {
      //   final credential = await FirebaseAuth.instance
      //       .signInWithEmailAndPassword(
      //     email: state.email,
      //     password: state.password,
      //   );
      //
      //   final userDoc = await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(credential.user!.uid)
      //       .get();
      //
      //   final user = UserModel.fromJson(userDoc.data()!);
      //   ref.read(userProvider.notifier).setUser(user);
      // } else {
      //   final credential = await FirebaseAuth.instance
      //       .createUserWithEmailAndPassword(
      //     email: state.email,
      //     password: state.password,
      //   );
      //

      if (state.isLogin) {

        final presentUser = DataService().loginUser(state.email, state.password);

        if (presentUser == null) {
          throw Exception('Invalid email or password.');
        }
        print( presentUser);
        ref.read(userProvider.notifier).setUser(presentUser);
        state = state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          // keep isLogin: true
        );
      } else {
        final newUser = DataService().createUser(
          state.name,
          state.email,
          state.password,
          '',
        );

        ref.read(userProvider.notifier).setUser(newUser);
      }

      //
      //   await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(newUser.id)
      //       .set(newUser.toJson());
      //

      // }
      //
      state = validatedState.copyWith(
        isSubmitting: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Authentication failed: ${e.toString()}',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    // Clear user from userProvider
    ref.read(userProvider.notifier).clearUser();

    // Reset auth state
    state = const AuthState(
      isLogin: true,
      email: '',
      password: '',
      name: '',
      infoMessage: 'Logged out successfully',
    );

    // TODO: Firebase logout
    // await FirebaseAuth.instance.signOut();
  }

  // Clear messages
  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      infoMessage: null,
    );
  }

  // Reset success state
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

  // Static validation methods
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  static int _passwordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) score++;
    return score;
  }
}

@riverpod
bool isLoginMode(IsLoginModeRef ref) {
  return ref.watch(authProvider).isLogin;
}

// Is form valid?
@riverpod
bool isFormValid(IsFormValidRef ref) {
  return ref.watch(authProvider).isValid;
}

// Is submitting?
@riverpod
bool isSubmitting(IsSubmittingRef ref) {
  return ref.watch(authProvider).isSubmitting;
}

// Password strength
@riverpod
int passwordStrength(PasswordStrengthRef ref) {
  return ref.watch(authProvider).passwordStrength;
}
