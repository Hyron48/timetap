import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timetap/language/language.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp passwordRegex =
      RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Languages.of(context)!.languageLoginLabels.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
                child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText:
                          Languages.of(context)!.languageLoginLabels.email,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Languages.of(context)!
                            .validationLabels
                            .fieldEmpty;
                      }
                      if (!emailRegex.hasMatch(value)) {
                        return Languages.of(context)!
                            .validationLabels
                            .fieldNotValid;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: Languages.of(context)!.languageLoginLabels.password,
                      errorMaxLines: 3,
                      suffixIcon: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(fit: BoxFit.scaleDown, "assets/svg/eye.svg"),
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Languages.of(context)!
                            .validationLabels
                            .fieldEmpty;
                      }
                      if (!passwordRegex.hasMatch(value)) {
                        return Languages.of(context)!
                            .validationLabels
                            .passwordNotValid;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState!.save();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ))));
  }
}
