import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timetap/bloc/locale_cubit.dart';
import 'package:timetap/utils/constants.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../utils/regex.dart';
import '../../utils/routes.dart';
import '../shared/custom_text_form_field.dart';
import '../shared/language_dropdown.dart';

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
        actions: [
          LanguageDropdown(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocaleCubit, Locale>(
            listener: (BuildContext context, Locale state) {
              formKey.currentState?.reset();
              formKey.currentState?.validate();
            },
          ),
          BlocListener<AuthBloc, BaseAuthState>(
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
          ),
        ],
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: SvgPicture.asset(
                            'assets/svg/login_placeholder.svg',
                            width: (MediaQuery.of(context).size.width / 5),
                            height: (MediaQuery.of(context).size.height / 5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            AppLocalizations.of(context)
                                ?.loginTitle
                                .toUpperCase() ??
                                'Not found',
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              color: bluePrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: CustomTextFormField(
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: CustomTextFormField(
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
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  ?.notRegisteredMessage ??
                                  'Not Found',
                            ),
                            Spacer(),
                            OutlinedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushReplacementNamed(Routes.registerRoute),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: bluePrimary),
                                  backgroundColor: white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                              child: Text(
                                AppLocalizations.of(context)?.signup ??
                                    'Not Found',
                                style: TextStyle(color: bluePrimary),
                              ),
                            ),
                          ],
                        )
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
                    onPressed: () => submitLoginForm(),
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
                      AppLocalizations.of(context)?.loginButton ??
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
