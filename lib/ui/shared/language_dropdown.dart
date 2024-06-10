import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/locale_cubit.dart';
import '../../utils/constants.dart';

class LanguageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              icon: SizedBox.shrink(),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: SvgPicture.asset(
                          locale.languageCode == 'it'
                              ? 'assets/svg/it_flag.svg'
                              : 'assets/svg/us_flag.svg',
                          width: 25,
                          height: 25,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        locale.languageCode == 'it' ? 'Italiano' : 'English',
                        style: TextStyle(fontWeight: lightFontWeight),
                      ),
                    ],
                  ),
                );
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return <Locale>[
                  Locale('it', 'IT'),
                  Locale('en', 'US'),
                ].map<Widget>((Locale locale) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SvgPicture.asset(
                        locale.languageCode == 'it'
                            ? 'assets/svg/it_flag.svg'
                            : 'assets/svg/us_flag.svg',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  );
                }).toList();
              },
              dropdownColor: Colors.white,
              isDense: true,
            ),
          ),
        );
      },
    );
  }
}
