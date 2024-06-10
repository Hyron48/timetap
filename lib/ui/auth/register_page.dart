import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';
import 'package:timetap/models/auth/registration_model.dart';

import '../../utils/constants.dart';
import '../../utils/regex.dart';
import '../../utils/routes.dart';
import '../shared/custom_text_form_field.dart';
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
      context
          .read<AuthBloc>()
          .add(AuthRegisterEvent(registrationModel: request));
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
            padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/registration_placeholder.svg',
                          width: (MediaQuery.of(context).size.width / 5),
                          height: (MediaQuery.of(context).size.height / 5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)
                                  ?.registrationTitle
                                  .toUpperCase() ??
                              'Not found',
                          style: TextStyle(
                            fontSize: fontSizeTitle,
                            color: bluePrimary,
                          ),
                        ),
                        CustomTextFormField(
                          textEditingController: _firstNameController,
                          label: AppLocalizations.of(context)?.firstName ??
                              'Not Found',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                      ?.isFieldEmpty ??
                                  'Not Found';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          textEditingController: _lastNameController,
                          label: AppLocalizations.of(context)?.lastName ??
                              'Not Found',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                      ?.isFieldEmpty ??
                                  'Not Found';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          textEditingController: _emailController,
                          label: AppLocalizations.of(context)?.email ??
                              'Not Found',
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
                          textInputAction: TextInputAction.next,
                          suffixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(end: 12.0),
                            child: Icon(
                              Icons.alternate_email_outlined,
                              color: lightGrey,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          textEditingController: _passwordController,
                          obscureText: !isPasswordVisible,
                          label: AppLocalizations.of(context)?.password ??
                              'Not Found',
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
                          textInputAction: TextInputAction.next,
                          suffixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(end: 12.0),
                            child: GestureDetector(
                              child: isPasswordVisible
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      color: lightGrey,
                                    )
                                  : Icon(
                                      Icons.visibility_outlined,
                                      color: lightGrey,
                                    ),
                              onTap: () => setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          textEditingController: _confirmPasswordController,
                          obscureText: !isConfirmPasswordVisible,
                          label:
                              AppLocalizations.of(context)?.confirmPassword ??
                                  'Not Found',
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
                            if (_passwordController.value.text != '' &&
                                value != _passwordController.value.text) {
                              return AppLocalizations.of(context)
                                      ?.passwordNotMatch ??
                                  'Not Found';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          suffixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(end: 12.0),
                            child: GestureDetector(
                              child: isConfirmPasswordVisible
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      color: lightGrey,
                                    )
                                  : Icon(
                                      Icons.visibility_outlined,
                                      color: lightGrey,
                                    ),
                              onTap: () => setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                      ?.alreadyRegisteredMessage ??
                                  'Not Found',
                            ),
                            Spacer(),
                            OutlinedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushReplacementNamed(Routes.initialRoute),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: bluePrimary),
                                  backgroundColor: white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                              child: Text(
                                AppLocalizations.of(context)?.signIn ??
                                    'Not Found',
                                style: TextStyle(color: bluePrimary),
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
                    onPressed: () => submitRegisterForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bluePrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: sendingApiBtn
                        ? SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              color: white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)?.registrationButton ??
                                'Not Found',
                            style: TextStyle(color: white),
                          ),
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
