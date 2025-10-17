import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<ToggleAuthMode>(_onToggleAuthMode);
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthNameChanged>(_onNameChanged);
    on<ForgotPassword>(_onForgotPassword);
    on<SubmitAuthForm>(_onSubmitAuthForm);
  }

  void _onToggleAuthMode(ToggleAuthMode event, Emitter<AuthState> emit) {
    emit(state.copyWith(isLogin: !state.isLogin, errorMessage: null));
  }

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    emit(_validate(state.copyWith(email: event.email, errorMessage: null)));
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    emit(_validate(state.copyWith(password: event.password, errorMessage: null)));
  }

  void _onNameChanged(AuthNameChanged event, Emitter<AuthState> emit) {
    emit(_validate(state.copyWith(name: event.name, errorMessage: null)));
  }

  void _onForgotPassword(ForgotPassword event, Emitter<AuthState> emit) async {
    if (!isValidEmail(state.email)) {
      emit(state.copyWith(errorMessage: 'Enter a valid email to reset password.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    await Future.delayed(const Duration(seconds: 1)); // simulate email sending

    emit(state.copyWith(
      isSubmitting: false,
      infoMessage: 'Password reset link sent to ${state.email}',
    ));
  }

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

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');
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

  void _onSubmitAuthForm(SubmitAuthForm event, Emitter<AuthState> emit) async {
    
    // Validate all fields first
    final validatedState = _validate(state);
    if (!validatedState.isValid) {
      emit(validatedState.copyWith(errorMessage: 'Please validate all fields correctly', infoMessage: null));
      return;
    }

    emit(validatedState.copyWith(isSubmitting: true, errorMessage: null, infoMessage: null));

    // Simulate login/register delay
    await Future.delayed(const Duration(seconds: 1));

    emit(validatedState.copyWith(isSubmitting: false, isSuccess: true));
  }

}
