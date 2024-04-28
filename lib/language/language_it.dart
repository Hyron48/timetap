import 'language.dart';
import '../models/languages-model.dart';

class LanguageIt extends Languages {
  @override
  LanguagesLoginModel get languageLoginLabels {
    String loginTitle = 'Login';
    String email = 'Email';
    String password = 'Password';

    return LanguagesLoginModel(loginTitle, email, password);
  }

  @override
  ValidationModel get validationLabels {
    String isFieldEmpty = 'Campo obbligatorio';
    String fieldNotValid = 'Campo non valido';
    String passwordNotValid = 'La password deve essere minimo di otto caratteri, almeno una lettera e un numero';

    return ValidationModel(isFieldEmpty, fieldNotValid, passwordNotValid);
  }
}