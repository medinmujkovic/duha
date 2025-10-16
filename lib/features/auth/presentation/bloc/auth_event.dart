import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleAuthMode extends AuthEvent {}

class AuthEmailChanged extends AuthEvent {
  final String email;
  AuthEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  AuthPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class AuthNameChanged extends AuthEvent {
  final String name;
  AuthNameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class SubmitAuthForm extends AuthEvent {}


class ForgotPassword extends AuthEvent {
  ForgotPassword();
}