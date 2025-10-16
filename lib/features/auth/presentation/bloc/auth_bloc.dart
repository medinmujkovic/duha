import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<ToggleAuthMode>(_onToggleAuthMode);
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthNameChanged>(_onNameChanged);
    on<SubmitAuthForm>(_onSubmitAuthForm);
    on<ForgotPassword>(_onForgotPassword);
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

  void _onSubmitAuthForm(SubmitAuthForm event, Emitter<AuthState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Please fill all fields correctly.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    await Future.delayed(const Duration(seconds: 1)); // simulate backend

    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }

  void _onForgotPassword(ForgotPassword event, Emitter<AuthState> emit) async {
    if (!_isValidEmail(state.email)) {
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
    final validEmail = _isValidEmail(s.email);
    final validName = s.isLogin ? true : s.name.trim().length >= 3;
    final passwordStrength = _passwordStrength(s.password);
    final validPassword = passwordStrength >= 3;

    final valid = validEmail && validName && validPassword;
    return s.copyWith(
      isValid: valid,
      passwordStrength: passwordStrength,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Returns 0–4 depending on how strong the password is
  int _passwordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) score++;
    return score;
  }

}
