part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final BlocStatus status;
  final String? errorMessage;
  final bool rememberMe;

  const LoginState({
    this.email = '',
    this.password = '',
    this.status = BlocStatus.empty,
    this.errorMessage,
    this.rememberMe = false,
  });

  @override
  List<Object> get props => [email, password, status, rememberMe];

  LoginState copyWith({
    String? email,
    String? password,
    BlocStatus? status,
    String? errorMessage,
    bool? rememberMe,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        rememberMe: rememberMe ?? this.rememberMe,
      );
}
