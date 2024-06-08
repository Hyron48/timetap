part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginState extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginState({
    required this.email,
    required this.password,
  });
}

class AuthLogoutEvent extends AuthEvent {}
