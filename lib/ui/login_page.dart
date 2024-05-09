import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          title: Text('temp'),
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
                          'temp'
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'temp';
                      }
                      if (!emailRegex.hasMatch(value)) {
                        return 'temp';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'temp',
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
                        return 'temp';
                      }
                      if (!passwordRegex.hasMatch(value)) {
                        return 'temp';
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
