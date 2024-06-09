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

class RegistrationUserSuccessState extends BaseAuthState {
  final String email;
  const RegistrationUserSuccessState({
    super.authStatus = AuthStatus.authenticated,
    required this.email,
  });
}

class RegistrationUserErrorState extends BaseAuthState {
  const RegistrationUserErrorState({
    super.authStatus = AuthStatus.unauthenticated,
  });
}
