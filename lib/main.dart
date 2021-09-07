import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/components/routes/CategoryPage.dart';
import 'package:project_ez_finance/screens/Layout.dart';
import 'package:project_ez_finance/themes/DTheme.dart';
import 'package:project_ez_finance/themes/DThemeLight.dart';
import 'package:project_ez_finance/components/routes/AccountPage.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDatabase();
  runApp(DThemeContainer(
    initialDTheme: DThemeLight(),
    child: MyApp(),
  ));
}

void setupDatabase() async {}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale("de"),
        Locale("en"),
      ],
      title: 'Dollavu',
      theme: DTheme.of(context)?.themeData,
      home: Layout(),
      routes: {
        "account": (context) => AccountPage(),
        "category": (context) => CategoryPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
