import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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


}