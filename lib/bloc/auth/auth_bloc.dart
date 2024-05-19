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
  late final StreamSubscription _authRepositorySubscription;

  static BaseAuthState _determineInitialState(AuthRepository authRepository) {
    if (authRepository.currentLoginModel.isNotEmpty && authRepository.currentLoginModel.isLogged) {
      return AuthenticatedAuthState(loginModel: authRepository.currentLoginModel);
    } else {
      return const UnauthenticatedAuthState();
    }
  }

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(_determineInitialState(authRepository)) {

    on<AuthStateChanged>(_onAuthStateChanged);

    _authRepositorySubscription = _authRepository.authStateStream.listen(
      (authState) => add(AuthStateChanged(authState)),
    );
  }

  // void _logout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
  //   await _authRepository.logout();
  //   emit(const AuthState.unauthenticated());
  // }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<BaseAuthState> emit) {
    if (event.authState.authStatus == AuthStatus.authenticated) {
      emit(AuthenticatedAuthState(loginModel: _authRepository.currentLoginModel));
    } else if (event.authState.authStatus == AuthStatus.unauthorized) {
      emit(const UnauthorizedAuthState());
    } else {
      emit(const UnauthenticatedAuthState());
    }
  }

  @override
  Future<void> close() {
    _authRepositorySubscription.cancel();
    return super.close();
  }
}
