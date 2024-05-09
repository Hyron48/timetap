part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState._({
    required this.authStatus,
    this.loginModel = LoginModel.empty,
  });

  final AuthStatus authStatus;
  final LoginModel loginModel;

  const AuthState.authenticated(LoginModel loginModel) : this._(authStatus: AuthStatus.authenticated, loginModel: loginModel);

  const AuthState.unauthenticated() : this._(authStatus: AuthStatus.unauthenticated);

  const AuthState.unauthorized() : this._(authStatus: AuthStatus.unauthorized);

  const AuthState.empty() : this._(authStatus: AuthStatus.empty);

  @override
  List<Object> get props => [authStatus, loginModel];
}
