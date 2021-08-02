import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/blocs/bloc/database_event.dart';
import 'package:project_ez_finance/blocs/bloc/database_state.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';
import './bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  List<Transaction> transactions = [];
  late Box<Transaction> transactionBox;
  final TransactionFilter filter = TransactionFilter();

  DatabaseBloc(DatabaseState initialState) : super(initialState) {
    setupDatabase();
  }

  @override
  Stream<DatabaseState> mapEventToState(
    DatabaseEvent event,
  ) async* {
    if (event is GetTransaction) {
      yield TransactionLoading();
      yield TransactionLoaded(transactions);
    } else if (event is AddTransaction) {
      saveTransaction(event.transaction);
      yield TransactionLoaded(transactions);
    } else if (event is DeleteAll) {
      yield TransactionLoading();
      deleteAllTransactions();
      yield TransactionLoaded([]);
    }
  }

  void saveTransaction(Transaction transaction) async {
    transaction.addDateTime = DateTime.now();
    await transactionBox.add(transaction);
    transactions.add(transaction);
  }

  void deleteAllTransactions() async {
    transactions.clear();
    await transactionBox.clear();
  }

  void setupDatabase() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Registering all adapters
    Hive.registerAdapter(CategoryIconAdapter());
    Hive.registerAdapter(CategoryIconDataAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(RepetitionAdapter());
    Hive.registerAdapter(CalenderUnitAdapter());
    Hive.registerAdapter(AccountAdapter());

    transactionBox = await Hive.openBox("transaction");
    transactionBox.values.forEach((item) => transactions.add(item));
  }
}
