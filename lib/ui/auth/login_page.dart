import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/utils/constants.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../utils/regex.dart';
import '../../utils/routes.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({
    super.key,
  });

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool sendingApiBtn = false;
  bool isPasswordVisible = false;

  void changeLoadingApiStatus(bool valToAssign) {
    setState(() {
      sendingApiBtn = valToAssign;
    });
  }

  Future<void> submitLoginForm() async {
    if (formKey.currentState?.validate() == true) {
      context.read<AuthBloc>().add(
            AuthLoginEvent(
              email: _emailController.value.text,
              password: _passwordController.value.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.loginTitle ?? 'Not found'),
      ),
      body: BlocListener<AuthBloc, BaseAuthState>(
        listener: (BuildContext context, BaseAuthState loginState) {
          if (loginState is InProgressAuthenticationState) {
            changeLoadingApiStatus(true);
            return;
          }

          if (loginState is AuthenticatedAuthState) {
            Navigator.of(context).pushReplacementNamed(Routes.initialRoute);
          }

          changeLoadingApiStatus(false);
          if (loginState is UnauthenticatedAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                AppLocalizations.of(context)?.generalErrorMessage ??
                    'Not Found',
              )),
            );
          }
        },
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)?.email ??
                                'Not Found',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                      ?.isFieldEmpty ??
                                  'Not Found';
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return AppLocalizations.of(context)
                                      ?.fieldNotValid ??
                                  'Not Found';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !isPasswordVisible,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)?.password ??
                                'Not Found',
                            errorMaxLines: 3,
                            suffixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(end: 12.0),
                                child: GestureDetector(
                                  child: isPasswordVisible
                                      ? Icon(Icons.visibility_off_outlined)
                                      : Icon(Icons.visibility_outlined),
                                  onTap: () => setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  }),
                                )),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                      ?.isFieldEmpty ??
                                  'Not Found';
                            }
                            if (!passwordRegex.hasMatch(value)) {
                              return AppLocalizations.of(context)
                                      ?.passwordNotValid ??
                                  'Not Found';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Text(AppLocalizations.of(context)
                                    ?.notRegisteredMessage ??
                                'Not Found'),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed(Routes.registerRoute),
                              child: Text(
                                AppLocalizations.of(context)?.thereMessage ??
                                    'Not Found',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: bluePrimary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    (MediaQuery.of(context).viewInsets.bottom == 0) ? 50.0 : 0,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      submitLoginForm();
                    },
                    child: sendingApiBtn
                        ? CircularProgressIndicator(color: white)
                        : Text(AppLocalizations.of(context)?.loginButton ??
                            'Not Found'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
