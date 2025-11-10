import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/common/data_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../states/auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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

      await _firebaseAuth.sendPasswordResetEmail(
        email: state.email,
      );
      
      state = state.copyWith(
        isSubmitting: false,
        infoMessage: 'Password reset link sent to ${state.email}',
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to send reset email. Please try again.';
      
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred.',
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
      if (state.isLogin) {
        // Login with Firebase Auth
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        // Get user data from Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .get();

        if (!userDoc.exists) {
          throw Exception('User data not found');
        }

        final user = UserModel.fromJson(userDoc.data()!);
        ref.read(userProvider.notifier).setUser(user);

        state = state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        );
      } else {
        // Register with Firebase Auth
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        // Create user model
        final newUser = UserModel(
          id: credential.user!.uid,
          name: state.name,
          email: state.email,
          avatar: '',
          xp: 0,
          level: 1,
          streak: 0,
          password: '', // Don't store password in Firestore
        );

        // Save user to Firestore
        await _firestore
            .collection('users')
            .doc(newUser.id)
            .set(newUser.toJson());

        // Update display name in Firebase Auth
        await credential.user!.updateDisplayName(state.name);

        // Set user in provider
        ref.read(userProvider.notifier).setUser(newUser);

        state = state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Authentication failed';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Authentication failed: ${e.message}';
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
  // Logout
   Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _firebaseAuth.signOut();

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
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to logout: ${e.toString()}',
      );
    }
  }

  // Check if user is already logged in
  Future<void> checkAuthState() async {
    final user = _firebaseAuth.currentUser;
    
    if (user != null) {
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = UserModel.fromJson(userDoc.data()!);
          ref.read(userProvider.notifier).setUser(userData);
        }
      } catch (e) {
        print('Error checking auth state: $e');
      }
    }
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
