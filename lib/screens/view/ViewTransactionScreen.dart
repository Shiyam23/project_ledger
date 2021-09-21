import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_state.dart';
import 'package:project_ez_finance/components/IconListTile.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarSection.dart';

class ViewTransactionScreen extends StatefulWidget {
  final TransactionRequest request = TransactionRequest(
      searchText: null,
      viewMode: ViewMode.List,
      timeMode: TimeMode.Individual,
      sortMode: SortMode.DateAsc,
      dateRange: DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month),
          end: DateTime(DateTime.now().year, DateTime.now().month + 1)
              .subtract(Duration(days: 1))));
  ViewTransactionScreen({Key? key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewTransactionScreen> {
  TransactionBloc? databaseBloc;
  Function eq = const ListEquality().equals;
  @override
  void initState() {
    super.initState();
    databaseBloc = BlocProvider.of<TransactionBloc>(context);
    databaseBloc?.add(GetTransaction(widget.request));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ViewFilterBarSection(
          request: widget.request,
        ),
        BlocBuilder<TransactionBloc, TransactionState>(
          buildWhen: (previousState, currentState) {
            return !(previousState is TransactionLoaded &&
                    currentState is TransactionLoaded) ||
                !eq(previousState.transactionList,
                    currentState.transactionList);
          },
          builder: (BuildContext context, TransactionState state) {
            if (state is TransactionLoaded) {
              return Flexible(
                child: Scrollbar(
                  child: ListView.builder(
                      key: ValueKey(state.transactionList.length),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: state.transactionList.length,
                      dragStartBehavior: DragStartBehavior.down,
                      itemBuilder: (BuildContext context, int index) {
                        Transaction transaction = state.transactionList[index];
                        return Card(
                          elevation: 3.0,
                          child: IconListTile(
                            selectable: true,
                            key: ObjectKey(transaction),
                            tile: transaction,
                          ),
                        );
                      }),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
