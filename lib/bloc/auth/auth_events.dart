part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStateChanged extends AuthEvent {
  const AuthStateChanged(this.authState);

  final AuthState authState;

  @override
  List<Object> get props => [authState];
}
