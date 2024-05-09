import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/repository/auth_repository.dart';
import '../../models/login_model.dart';
import '../../utils/enum.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
        super(
        authRepository.currentLoginModel.isNotEmpty && authRepository.currentLoginModel.isLogged
            ? AuthState.authenticated(authRepository.currentLoginModel)
            : const AuthState.unauthenticated(),
      ) {
    on<AuthStateChanged>(_onAuthStateChanged);

    _authRepositorySubscription = _authRepository.authStateStream.listen(
          (authState) => add(
          AuthStateChanged(authState)
      ),
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription _authRepositorySubscription;

  // void _logout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
  //   await _authRepository.logout();
  //   emit(const AuthState.unauthenticated());
  // }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.authState.authStatus == AuthStatus.authenticated) {
      emit(AuthState.authenticated(_authRepository.currentLoginModel));
    } else if (event.authState.authStatus == AuthStatus.unauthorized) {
      emit(const AuthState.unauthorized());
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authRepositorySubscription.cancel();
    return super.close();
  }
}