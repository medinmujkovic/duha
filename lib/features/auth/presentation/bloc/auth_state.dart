import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String email;
  final String password;
  final String name;
  final bool isLogin;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isValid;
  final String? errorMessage;
  final String? infoMessage;
  final int passwordStrength;

  const AuthState({
    this.email = '',
    this.password = '',
    this.name = '',
    this.isLogin = true,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isValid = false,
    this.errorMessage,
    this.infoMessage,
    this.passwordStrength = 0,
  });

  AuthState copyWith({
    String? email,
    String? password,
    String? name,
    bool? isLogin,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isValid,
    String? errorMessage,
    String? infoMessage,
    int? passwordStrength,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      isLogin: isLogin ?? this.isLogin,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        isLogin,
        isSubmitting,
        isSuccess,
        isValid,
        errorMessage,
        infoMessage,
        passwordStrength,
      ];
}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class PasswordResetEmailSent extends AuthState {}

