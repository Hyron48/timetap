import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/repository/auth_repository.dart';
import '../../models/auth/login_model.dart';
import '../../utils/enum.dart';

part 'auth_events.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, BaseAuthState> {
  final AuthRepository _authRepository;

  static BaseAuthState _determineInitialState(AuthRepository authRepository) {
    if (authRepository.currentLoginModel.isNotEmpty) {
      return AuthenticatedAuthState(
          loginModel: authRepository.currentLoginModel);
    } else {
      return const UnauthenticatedAuthState();
    }
  }

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(_determineInitialState(authRepository)) {
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthLogoutEvent>(_onLogout);
  }

  void _onLogout(AuthLogoutEvent event, Emitter<BaseAuthState> emit) async {
    await _authRepository.logout();
    emit(const UnauthenticatedAuthState());
  }

  void _onAuthStateChanged(
      AuthStateChanged event, Emitter<BaseAuthState> emit) {
    if (event.authState.authStatus == AuthStatus.authenticated) {
      emit(AuthenticatedAuthState(
          loginModel: _authRepository.currentLoginModel));
    } else if (event.authState.authStatus == AuthStatus.unauthorized) {
      emit(const UnauthorizedAuthState());
    } else {
      emit(const UnauthenticatedAuthState());
    }
  }

  bool isUserAlreadyLogged() {
    return _authRepository.currentLoginModel.jwt != '';
  }
}
