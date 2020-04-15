import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/screens/Layout.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:project_ez_finance/themes/DTheme.dart';
import 'package:project_ez_finance/themes/DThemeLight.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDatabase();

  runApp(DThemeContainer(
    initialDTheme: DThemeLight(),
    child: MyApp(),
  ));
}

void setupDatabase() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Registering all adapters
  // Hive.registerAdapter(CategoryIconAdapter());
  // Hive.registerAdapter(CategoryIconDataAdapter());
  // Hive.registerAdapter(CategoryAdapter());
  // Hive.registerAdapter(TransactionAdapter());
  // Hive.registerAdapter(RepetitionAdapter());
  // Hive.registerAdapter(AccountAdapter());

  // Opening all boxes
  await Hive.openBox("transaction");
  await Hive.openBox("category");
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dollavu',
      theme: DTheme.of(context)?.themeData,
      home: Layout(),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
