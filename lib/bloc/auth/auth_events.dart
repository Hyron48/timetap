part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStateChanged extends AuthEvent {
  const AuthStateChanged(this.authState);

  final BaseAuthState authState;

  @override
  List<Object> get props => [authState];
}

class AuthLogoutEvent extends AuthEvent {}
