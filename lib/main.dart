import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ug_covid_trace/nav.dart';
import 'package:ug_covid_trace/ui/onboarding/onboarding_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('ugTracerBox');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness brightness = Brightness.light;
  final bool onboarding =
      Hive.box('ugTracerBox').get('onboardingSeen', defaultValue: null);

  @override
  Widget build(BuildContext context) {
    final materialTheme = new ThemeData(
      primaryColor: Color(0xff1c3857),
      primaryColorLight: Color(0xffd8e5f3),
      primaryColorDark: Color(0xff254b74),
      accentColor: Color(0xffe0a700),
    );
    final materialDarkTheme = new ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.amber,
    );

    final cupertinoTheme = new CupertinoThemeData(
      brightness: brightness,
      primaryColor: CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemBlue,
        darkColor: CupertinoColors.systemOrange,
      ),
    );
    return PlatformProvider(
      builder: (context) => PlatformApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        title: 'Ug Covid Trace',
        android: (_) {
          return MaterialAppData(
            theme: materialTheme,
            darkTheme: materialDarkTheme,
            // themeMode: brightness == Brightness.light
            //     ? ThemeMode.light
            //     : ThemeMode.dark,
          );
        },
        ios: (_) {
          return CupertinoAppData(
            theme: cupertinoTheme,
          );
        },
        home: onboarding == true ? TraceNav() : OnboardingScreen(),
      ),
    );
  }
}
