import 'language.dart';
import '../models/languages-model.dart';

class LanguageEn extends Languages {
  @override
  LanguagesLoginModel get languageLoginLabels {
    String title = 'Login';
    String email = 'Email';
    String password = 'Password';

    return LanguagesLoginModel(title, email, password);
  }

  @override
  ValidationModel get validationLabels {
    String isFieldEmpty = 'Required field';
    String fieldNotValid = 'Field not valid';
    String passwordNotValid = 'The password must be at least eight characters, at least one letter and one number';

    return ValidationModel(isFieldEmpty, fieldNotValid, passwordNotValid);
  }
}