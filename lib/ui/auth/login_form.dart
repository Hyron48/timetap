import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/utils/useful_constants.dart';

import '../../bloc/login/login_cubit.dart';
import '../../l10n/backend_localizations.dart';
import '../../repository/auth_repository.dart';
import '../../utils/enum.dart';
import '../../widgets/snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isPasswordHide = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _switchValue = ValueNotifier<bool>(false);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotPasswordController = TextEditingController();
  final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp passwordRegex = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");
  bool sendingApiBtn = false;

  @override
  void initState() {
    super.initState();
    if (context.read<AuthRepository>().currentLoginModel.isNotEmpty && context.read<AuthRepository>().currentLoginModel.isLogged) {
      _emailController.value = _emailController.value.copyWith(
          text: context.read<AuthRepository>().currentLoginModel.email
      );
      _passwordController.value = _passwordController.value.copyWith(
          text: context.read<AuthRepository>().currentLoginModel.password
      );
      _switchValue.value = true;
    }

    if (context.read<LoginCubit>().state.rememberMe) {
      _emailController.value = _emailController.value.copyWith(
          text: context.read<LoginCubit>().state.email
      );
      _passwordController.value = _passwordController.value.copyWith(
          text: context.read<LoginCubit>().state.password
      );
      _switchValue.value = context.read<LoginCubit>().state.rememberMe;
      // BlocProvider<ForgotPasswordCubit>(
      //   create: (_) => ForgotPasswordCubit(
      //     context.read<AuthRepository>(),
      //   ),
      // );
    }
  }

  void changeLoadingApiStatus() {
    setState(() {
      sendingApiBtn = !sendingApiBtn;
    });
  }

  void submitLoginForm() async {
    if (formKey.currentState?.validate() == true) {
      changeLoadingApiStatus();
      context.read<LoginCubit>().setupField(
          email: _emailController.value.text,
          password: _passwordController.value.text,
          rememberMe: _switchValue.value
      );
      await context.read<LoginCubit>().loginWithCredentials();
      debugPrint('response > ${context.read<AuthRepository>().currentLoginModel}');
      changeLoadingApiStatus();
    }
  }

  @override
  void dispose() {
    isPasswordHide.dispose();
    formKey.currentState?.dispose();
    _switchValue.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (LoginState current, LoginState next) => current.status != next.status,
          listener: (BuildContext context, LoginState loginState) {
            switch (loginState.status) {
              case BlocStatus.inProgress:
                break;
              case BlocStatus.failure:
                showErrorSnackBar(
                  context: context,
                  message: BackendLocalizations.translate(loginState.errorMessage!),
                );
                break;
              case BlocStatus.success:
                print('login ok > ${loginState}');
                break;
              default:
                break;
            }
          },
        ),
      ],
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
                    return AppLocalizations.of(context)?.isFieldEmpty ?? 'Not Found';
                  }
                  if (!emailRegex.hasMatch(value)) {
                    return AppLocalizations.of(context)?.fieldNotValid ?? 'Not Found';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.password ?? 'Not Found',
                  errorMaxLines: 3,
                  suffixIcon: isPasswordHide.value ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.isFieldEmpty ?? 'Not Found';
                  }
                  if (!passwordRegex.hasMatch(value)) {
                    return AppLocalizations.of(context)?.passwordNotValid ?? 'Not Found';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.rememberMe ?? 'Not Found',
                    style: const TextStyle(
                        color: colorStatusSand
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _switchValue,
                    builder: (BuildContext context, bool value, Widget? child) => Switch(
                      value: value,
                      onChanged: (bool newValue) => _switchValue.value = newValue,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  submitLoginForm();
                },
                child: sendingApiBtn
                    ? CircularProgressIndicator(color: white)
                    :  Text(AppLocalizations.of(context)?.loginButton ?? 'Not Found'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}