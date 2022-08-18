import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/LoadingDialog.dart';
import 'package:project_ez_finance/components/ResponseDialog.dart';
import 'package:project_ez_finance/components/button/Button.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/services/DateTimeFormatter.dart';
import '../../models/CategoryChartInfo.dart';
import '../../models/Modes.dart';
import '../../models/Transaction.dart';
import '../../services/PDFGenerator.dart';

class HomeScreen extends StatefulWidget {

  final Future<void> Function(int) setPage;

  HomeScreen({
    Key? key,
    required this.setPage
  }) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    this.context.read<AccountChangeNotifier>().changed = true;
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.height * 0.001;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Invoice",
                            style: TextStyle(
                              fontSize: 27 * factor,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                            ),
                          ),
                          SizedBox(height: factor * 5),
                          FittedBox(
                            child: Text(_formatPreviousMonth(),
                              style: TextStyle(
                                fontSize: 22 * factor,
                                overflow: TextOverflow.fade,
                                color: Theme.of(context).primaryColor
                              ),
                            ),
                          ),
                          SizedBox(height: factor * 20),
                          RoundGradientButton(
                            onPressed: () => _createInvoice(context), 
                            text: "CREATE",
                            widthRatio: 0.3,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: const Image(
                          image: AssetImage('assets/icons/invoice_new.png')
                        ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Top 5 Categories",
                                  style: TextStyle(
                                    fontSize: factor * 27,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                  ),
                                ),
                                SizedBox(height: factor * 5),
                                FittedBox(
                                  child: Text(
                                    _formatCurrentMonth(),
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: factor * 22,
                                      color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RoundGradientButton(
                            onPressed: () {
                              widget.setPage(0);
                            }, 
                            text: "SEE MORE",
                            widthRatio: 0.3
                          )
                        ],
                      ),
                      AnimatedBuilder(
                    animation: context.read<AccountChangeNotifier>(),
                    builder: (context,_) {
                      return FutureBuilder(
                      future: context.read<AccountChangeNotifier>().categories,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        else {
                          List<CategoryChartInfo> chartList = 
                            snapshot.data as List<CategoryChartInfo>;
                          if (chartList.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.12,
                                    child: Image.asset("assets/icons/box2.png")
                                  ),
                                  const SizedBox(height: 10),
                                  Text("No transactions yet ..."),
                                ],
                              ),
                            );
                          }
                          return ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: 
                              diagramRow((snapshot.data as List<CategoryChartInfo>), context)
                          );
                        }
                      } 
                    );
                    },
                  ),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> diagramRow(List<CategoryChartInfo> list, BuildContext context) {
    double factor = MediaQuery.of(context).size.height * 0.001;
    double width = MediaQuery.of(context).size.width;
    double maxAmount = list[0].amount;
    return list.map((category) {
      return Padding(
       padding: const EdgeInsets.only(top: 20.0),
       child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: width / 8,
            width: width / 8,
            child: CategoryIcon(
              iconData: category.categoryIconData
            ),
          ),
          SizedBox(width: width * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: Text(
                  category.categoryName,
                  style: TextStyle(
                    inherit: true,
                    fontSize: factor * 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.secondary,
                        ]
                      )
                    ),
                    child: SizedBox(
                      width: width *0.65 * category.amount / maxAmount, 
                      height: width *0.065,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: (category.amount/maxAmount < 0.5) ? 
                            null : 
                            Text(
                            category.displayedAmount,
                            style: TextStyle(
                              overflow: TextOverflow.fade,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  (category.amount/maxAmount > 0.5) ? 
                    SizedBox() : 
                    Text(
                      category.displayedAmount,
                      style: TextStyle(
                        overflow: TextOverflow.fade,
                        color: Theme.of(context).primaryColor
                      )
                    ),
                ],
              ),
            ],
          )
        ],
    ),
     );
    }).toList();
  }

  String _formatCurrentMonth() {
    return DateTime.now().format(format: "yMMMM");
  }

  String _formatPreviousMonth() {
    DateTime now = DateTime.now();
    DateTime previousMonth = DateTime(now.year, now.month-1);
    return previousMonth.format(format: "yMMMM");
  }

  void _createInvoice(BuildContext context) async {
    final LoadingProgress loadingProgress = LoadingProgress();
    showDialog(
      context: context, 
      builder: (context) => LoadingDialog(
        loadingProgress: loadingProgress, 
        title: "Generating PDF",
      ),
      barrierDismissible: false
    );
    final TransactionBloc transactionBloc = 
      BlocProvider.of<TransactionBloc>(context);
    final TransactionRequest request = TransactionRequest(
      searchText: null,
      viewMode: ViewMode.List,
      timeMode: TimeMode.Individual,
      sortMode: SortMode.DateAsc,
      dateRange: DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month - 1),
          end: DateTime(DateTime.now().year, DateTime.now().month)
              .subtract(Duration(microseconds: 1))));
    transactionBloc.add(GetTransaction(request));
    await Future.doWhile(() {
      return Future.delayed(Duration(milliseconds: 100), () {
        return !(transactionBloc.state is TransactionLoaded);
      });
    });

    final List<Transaction> transactions = 
      (transactionBloc.state as TransactionLoaded).transactionList;
    
    if (transactions.isEmpty) {
      loadingProgress.finish();
      Navigator.pop(context);
      showTransactionsEmptyError(context);
      return;
    }
    final Invoice invoice = Invoice(
      transactions: transactions,
      color: Theme.of(context).primaryColor 
    );
    await invoice.openInvoice();
    loadingProgress.initialize(1);
    loadingProgress.forward();
    loadingProgress.finish();
  }

  void showTransactionsEmptyError(BuildContext context) async {
    await showDialog(
      context: context, 
      builder: (context) => ResponseDialog(
        description: "No transactions for this month", 
        response: Response.Error
      )
    );
  }


}
