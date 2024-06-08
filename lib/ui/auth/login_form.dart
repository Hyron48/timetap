import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/utils/constants.dart';

import '../../bloc/login/login_cubit.dart';
import '../../utils/enum.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _switchValue = ValueNotifier<bool>(false);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotPasswordController =
      TextEditingController();
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp passwordRegex =
      RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");
  bool sendingApiBtn = false;
  bool isPasswordVisible = false;

  void changeLoadingApiStatus(bool valToAssign) {
    setState(() {
      sendingApiBtn = valToAssign;
    });
  }

  void submitLoginForm() async {
    if (formKey.currentState?.validate() == true) {
      context.read<LoginCubit>().setupField(
          email: _emailController.value.text,
          password: _passwordController.value.text,
          rememberMe: _switchValue.value);
      await context.read<LoginCubit>().loginWithCredentials();
    }
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    _switchValue.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (LoginState current, LoginState next) =>
          current.status != next.status,
      listener: (BuildContext context, LoginState loginState) {
        switch (loginState.status) {
          case BlocStatus.inProgress:
            changeLoadingApiStatus(true);
            break;
          case BlocStatus.failure:
            changeLoadingApiStatus(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login fallito')),
            );
            break;
          case BlocStatus.success:
            changeLoadingApiStatus(false);
            Navigator.of(context).pushReplacementNamed('/');
            break;
          default:
            changeLoadingApiStatus(false);
            break;
        }
      },
      child: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.email ?? 'Not Found',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.isFieldEmpty ??
                        'Not Found';
                  }
                  if (!emailRegex.hasMatch(value)) {
                    return AppLocalizations.of(context)?.fieldNotValid ??
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
                  labelText:
                      AppLocalizations.of(context)?.password ?? 'Not Found',
                  errorMaxLines: 3,
                  suffixIcon: Padding(
                      padding: EdgeInsetsDirectional.only(end: 12.0),
                      child: GestureDetector(
                        child: isPasswordVisible
                            ? Icon(
                                Icons.visibility_off_outlined,
                              )
                            : Icon(
                                Icons.visibility_outlined,
                              ),
                        onTap: () => setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        }),
                      )),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.isFieldEmpty ??
                        'Not Found';
                  }
                  if (!passwordRegex.hasMatch(value)) {
                    return AppLocalizations.of(context)?.passwordNotValid ??
                        'Not Found';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  submitLoginForm();
                },
                child: sendingApiBtn
                    ? CircularProgressIndicator(color: white)
                    : Text(AppLocalizations.of(context)?.loginButton ??
                        'Not Found'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
