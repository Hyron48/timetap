import 'package:flutter/material.dart';
import '../models/languages-model.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  LanguagesLoginModel get languageLoginLabels;
  ValidationModel get validationLabels;
}