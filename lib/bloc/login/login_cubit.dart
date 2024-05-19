import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/auth_repository.dart';
import '../../utils/custom_exception.dart';
import '../../utils/enum.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository)
      : super(
          authRepository.currentLoginModel.isEmpty
              ? const LoginState()
              : LoginState(
                  email: authRepository.currentLoginModel.email,
                  password: authRepository.currentLoginModel.password,
                ),
        );

  Future<void> loginWithCredentials() async {
    emit(state.copyWith(status: BlocStatus.inProgress));
    try {
      await authRepository.login(email: state.email, password: state.password);
      emit(state.copyWith(status: BlocStatus.success));
    } on CustomException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: BlocStatus.failure,
        ),
      );
    }
  }

  void setupField({
    String? email,
    String? password,
    bool? rememberMe,
  }) => emit(
    state.copyWith(
        email: email,
        password: password,
        rememberMe: rememberMe
    ),
  );
}
