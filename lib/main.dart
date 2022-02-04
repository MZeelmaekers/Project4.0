import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:project40_mobile_app/pages/login.dart';

void main() {
  runApp(AnalyserApp());
}

class AnalyserApp extends StatelessWidget {
  const AnalyserApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directory = 'lib/i18n';

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('nl'), Locale('fr')],
      // Get the language of the smartphone
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }

        if (locale?.languageCode == 'nl') {
          return Locale('nl');
        }
        if (locale?.languageCode == 'fr') {
          return Locale('fr');
        }

        // default language
        return Locale('en');
      },
      debugShowCheckedModeBanner: false,
      title: 'VITO Analyser App',
      theme: ThemeData(
        fontFamily: 'ProximaNova',
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}
