import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/test.dart';
import 'package:timetap/models/auth/login_model.dart';
import 'package:timetap/repository/auth/auth_repository.dart';
import 'package:timetap/utils/custom_exception.dart';
import 'package:timetap/utils/flavor_config.dart';

void main() {
  setUpAll(() {
    FlavorConfig(
      flavor: Flavor.dev,
      values: const FlavorValues(
        appUrl: 'https://timetap-be-c63ba43413d7.herokuapp.com',
      ),
    );
    WidgetsFlutterBinding.ensureInitialized();
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('Login di un utente valido', () async {
    final authRepository = AuthRepository();
    const String validUserEmail = 'm.rossi@gmail.com';
    const String validUserPassword = 'Password1';

    await authRepository.login(email: validUserEmail, password: validUserPassword);

    expect(authRepository.currentLoginModel.email, validUserEmail);
    expect(authRepository.currentLoginModel.password, validUserPassword);
    expect(authRepository.currentLoginModel.jwt, isNotNull);
  });

  test('Login di un utente non valido', () async {
    final authRepository = AuthRepository();
    const String invalidUserEmail = 'm.rossi1@gmail.com';
    const String invalidUserPassword = 'Password1!';

    expect(() async => await authRepository.login(email: invalidUserEmail, password: invalidUserPassword), throwsA(isA<CustomException>()));
  });
}