import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_test/flutter_svg_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetap/bloc/locale_cubit.dart';
import 'package:timetap/ui/shared/language_dropdown.dart';

void main() {
  final italianFlagWidget = SvgPicture.asset('assets/svg/it_flag.svg');
  final englishFlagWidget = SvgPicture.asset('assets/svg/us_flag.svg');
  FlutterSecureStorage.setMockInitialValues({});

  testWidgets('LanguageDropdown mostra solo l\'icona della lingua selezionata, in italiano',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<LocaleCubit>(
            create: (BuildContext context) => LocaleCubit(),
            child: LanguageDropdown(),
          ),
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.svg(italianFlagWidget.bytesLoader), findsOneWidget);
  });

  testWidgets('Al click sul botton si apre la dropdown con le opzioni "Italiano" e "English"', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<LocaleCubit>(
            create: (BuildContext context) => LocaleCubit(),
            child: Center(
              child: SizedBox(
                width: 200,
                child: LanguageDropdown(),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButton<Locale>));
    await tester.pumpAndSettle();

    expect(find.text('Italiano'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.svg(italianFlagWidget.bytesLoader), findsAtLeast(1));
    expect(find.svg(englishFlagWidget.bytesLoader), findsAtLeast(1));
  });

  testWidgets('LanguageDropdown aggiorna la lingua dell\'app',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<LocaleCubit>(
            create: (BuildContext context) => LocaleCubit(),
            child: Center(
              child: SizedBox(
                width: 200,
                child: LanguageDropdown(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.svg(italianFlagWidget.bytesLoader), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<Locale>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    final localeCubit = BlocProvider.of<LocaleCubit>(tester.element(find.byType(LanguageDropdown))).state;

    expect(find.svg(englishFlagWidget.bytesLoader), findsOneWidget);
    expect(localeCubit, Locale('en', 'US'));
  });

  testWidgets('Aggiornamento manuale della lingua, ed aggiornamento dell\'icona',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<LocaleCubit>(
            create: (BuildContext context) => LocaleCubit(),
            child: Center(
              child: SizedBox(
                width: 200,
                child: LanguageDropdown(),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButton<Locale>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Italiano').last);
    await tester.pumpAndSettle();

    final localeCubit = BlocProvider.of<LocaleCubit>(
        tester.element(find.byType(LanguageDropdown)));
    localeCubit.setLanguage(locale: Locale('en', 'US'));
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.svg(englishFlagWidget.bytesLoader), findsOneWidget);
  });
}
