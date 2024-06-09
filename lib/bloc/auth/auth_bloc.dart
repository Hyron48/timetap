import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/models/auth/registration_model.dart';
import 'package:timetap/repository/auth/auth_repository.dart';
import '../../models/auth/login_model.dart';
import '../../utils/custom_exception.dart';
import '../../utils/enum.dart';

part 'auth_events.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, BaseAuthState> {
  final AuthRepository _authRepository;

  static BaseAuthState _determineInitialState(AuthRepository authRepository) {
    final currentLoginModel = authRepository.currentLoginModel;
    return currentLoginModel.isNotEmpty
        ? AuthenticatedAuthState(loginModel: currentLoginModel)
        : const UnauthenticatedAuthState();
  }

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(_determineInitialState(authRepository)) {
    on<AuthRegisterEvent>(_registerUser);
    on<AuthLoginEvent>(_loginWithCredentials);
    on<AuthLogoutEvent>(_onLogout);
  }

  Future<void> _registerUser(
      AuthRegisterEvent event,
      Emitter<BaseAuthState> emit,
      ) async {
    emit(const InProgressAuthenticationState());
    try {
      var apiSuccess = await _authRepository.register(registrationModel: event.registrationModel);
      emit(apiSuccess ? RegistrationUserSuccessState(email: event.registrationModel.email) : RegistrationUserErrorState());
    } on CustomException catch (e) {
      emit(const RegistrationUserErrorState());
    }
  }

  Future<void> _loginWithCredentials(
    AuthLoginEvent event,
    Emitter<BaseAuthState> emit,
  ) async {
    emit(const InProgressAuthenticationState());
    try {
      await _authRepository.login(email: event.email, password: event.password);
      emit(AuthenticatedAuthState(
          loginModel: _authRepository.currentLoginModel));
    } on CustomException catch (e) {
      emit(const UnauthenticatedAuthState());
    }
  }

  Future<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<BaseAuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const UnauthenticatedAuthState());
  }

  bool isUserAlreadyLogged() {
    return _authRepository.currentLoginModel.jwt != '';
  }

  String getUserEmail() {
    return _authRepository.currentLoginModel.email;
  }
}
