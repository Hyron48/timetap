class LanguagesLoginModel {
  String title;
  String email;
  String password;

  LanguagesLoginModel(this.title, this.email, this.password);
}

class ValidationModel {
  String fieldEmpty;
  String fieldNotValid;
  String passwordNotValid;

  ValidationModel(this.fieldEmpty, this.fieldNotValid, this.passwordNotValid);
}