import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/interfaces/i_secure_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(
      const Locale('en', 'EN')
  );

  void setLanguage({required Locale locale}) async {
      await ISecureStorage().saveUserLocale(locale: locale.languageCode);
      emit(locale);
  }
}