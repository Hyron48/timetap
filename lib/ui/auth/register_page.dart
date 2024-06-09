import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';
import 'package:timetap/models/auth/registration_model.dart';

import '../../utils/constants.dart';
import '../../utils/regex.dart';
import '../../utils/routes.dart';
import '../shared/language_dropdown.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool sendingApiBtn = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void changeLoadingApiStatus(bool valToAssign) {
    setState(() {
      sendingApiBtn = valToAssign;
    });
  }

  void submitRegisterForm() async {
    if (formKey.currentState?.validate() == true) {
      RegistrationModel request = RegistrationModel(
        firstName: _firstNameController.value.text,
        lastName: _lastNameController.value.text,
        email: _emailController.value.text,
        password: _passwordController.value.text,
      );
      context.read<AuthBloc>().add(AuthRegisterEvent(registrationModel: request));
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
        title: Text(
            AppLocalizations.of(context)?.registrationTitle ?? 'Not found'),
        actions: [
          LanguageDropdown(),
        ],
      ),
      body: BlocListener<AuthBloc, BaseAuthState>(
        listener: (BuildContext context, BaseAuthState registrationState) {
          if (registrationState is InProgressAuthenticationState) {
            changeLoadingApiStatus(true);
            return;
          }

          if (registrationState is RegistrationUserSuccessState) {
            Navigator.of(context).pushReplacementNamed(Routes.initialRoute);
          }

          changeLoadingApiStatus(false);
          if (registrationState is RegistrationUserErrorState) {
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
                            controller: _firstNameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)?.firstName ??
                                  'Not Found',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)?.isFieldEmpty ?? 'Not Found';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _lastNameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)?.lastName ??
                                  'Not Found',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)?.isFieldEmpty ?? 'Not Found';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
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
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !isConfirmPasswordVisible,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)?.password ??
                                  'Not Found',
                              errorMaxLines: 3,
                              suffixIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(end: 12.0),
                                  child: GestureDetector(
                                    child: isConfirmPasswordVisible
                                        ? Icon(Icons.visibility_off_outlined)
                                        : Icon(Icons.visibility_outlined),
                                    onTap: () => setState(() {
                                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
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
                              if (_passwordController.value.text != '' && value != _passwordController.value.text) {
                                return AppLocalizations.of(context)
                                    ?.passwordNotMatch ??
                                    'Not Found';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32),
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)
                                  ?.alreadyRegisteredMessage ??
                                  'Not Found'),
                              GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushReplacementNamed(Routes.initialRoute),
                                child: Text(
                                  AppLocalizations.of(context)?.signIn ??
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
                    )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    (MediaQuery.of(context).viewInsets.bottom == 0) ? 50.0 : 0,
                  ),
                  child: ElevatedButton(
                    onPressed: () => submitRegisterForm(),
                    child: sendingApiBtn
                        ? CircularProgressIndicator(color: white)
                        : Text(AppLocalizations.of(context)?.registrationButton ??
                        'Not Found'),
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
