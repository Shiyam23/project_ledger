import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/database_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/database_event.dart';
import 'package:project_ez_finance/blocs/bloc/database_state.dart';
import 'package:project_ez_finance/components/IconListTile.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarSection.dart';

class ViewTransactionScreen extends StatefulWidget {
  ViewTransactionScreen({Key? key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewTransactionScreen> {
  TransactionFilter? transactionFilter;
  DatabaseBloc? databaseBloc;
  int listKey = 0;
  @override
  void initState() {
    super.initState();
    databaseBloc = BlocProvider.of<DatabaseBloc>(context);
    databaseBloc!.add(GetTransaction());
  }

  @override
  Widget build(BuildContext context) {
    ValueKey key = ValueKey(DateTime.now());
    return Column(
      children: <Widget>[
        ViewFilterBarSection(),
        BlocBuilder(
          bloc: databaseBloc,
          builder: (BuildContext context, DatabaseState state) {
            if (state is TransactionInitial) {
              return Text("Initial");
            } else if (state is TransactionLoading) {
              return CircularProgressIndicator();
            } else if (state is TransactionLoaded) {
              return Flexible(
                child: Scrollbar(
                  key: key,
                  child: ListView.builder(
                      key: key,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: state.transactionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return IconListTile(
                          tile: state.transactionList[index],
                        );
                      }),
                ),
              );
            }
            return Text("not working");
          },
        ),
      ],
    );
  }
}
