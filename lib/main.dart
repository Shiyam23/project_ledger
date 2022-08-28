import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/routes/CategoryPage.dart';
import 'package:project_ez_finance/screens/Layout.dart';
import 'package:project_ez_finance/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmountController.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';
import 'package:project_ez_finance/themes/DTheme.dart';
import 'package:project_ez_finance/themes/DThemeLight.dart';
import 'package:project_ez_finance/components/routes/AccountPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase().setupDatabase();
  MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(DThemeContainer(
    initialDTheme: DThemeLight(),
    child: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountChangeNotifier(),
      child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Dollavu',
          theme: DTheme.of(context)?.themeData,
          home: Layout(),
          routes: {
            "account": (context) => AccountPage(),
            "category": (context) => CategoryPage(),
          },
          debugShowCheckedModeBanner: false,
        ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
