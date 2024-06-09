import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/locale_cubit.dart';

class LanguageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, state) {
        return DropdownButton<Locale>(
          underline: Container(),
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          value: state,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              context.read<LocaleCubit>().setLanguage(locale: newLocale);
            }
          },
          items: <Locale>[
            Locale('it', 'IT'),
            Locale('en', 'US'),
          ].map<DropdownMenuItem<Locale>>((Locale locale) {
            return DropdownMenuItem<Locale>(
              value: locale,
              child: Row(
                children: [
                  SvgPicture.asset(
                    locale.languageCode == 'it'
                        ? 'assets/svg/it-flag.svg'
                        : 'assets/svg/us-flag.svg',
                    width: 25,
                    height: 25,
                  ),
                  SizedBox(width: 8),
                  Text(
                    locale.languageCode == 'it' ? 'Italiano' : 'English',
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
