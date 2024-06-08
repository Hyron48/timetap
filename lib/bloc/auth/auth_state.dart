part of 'auth_bloc.dart';

class BaseAuthState extends Equatable {
  final AuthStatus authStatus;

  const BaseAuthState({
    required this.authStatus,
  });

  @override
  List<Object> get props => [];
}

class AuthenticatedAuthState extends BaseAuthState {
  final LoginModel loginModel;

  const AuthenticatedAuthState({
    required this.loginModel,
    super.authStatus = AuthStatus.authenticated,
  });
}

class UnauthenticatedAuthState extends BaseAuthState {
  const UnauthenticatedAuthState({
    super.authStatus = AuthStatus.unauthenticated,
  });
}

class EmptyAuthState extends BaseAuthState {
  const EmptyAuthState({
    super.authStatus = AuthStatus.empty,
  });
}

class InProgressAuthenticationState extends BaseAuthState {
  const InProgressAuthenticationState({
    super.authStatus = AuthStatus.inProgress,
  });
}
