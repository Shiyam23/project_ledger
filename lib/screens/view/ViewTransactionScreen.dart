import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction_state.dart';
import 'package:project_ez_finance/components/IconListTile.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarSection.dart';

class ViewTransactionScreen extends StatefulWidget {
  ViewTransactionScreen({Key key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ViewFilterBarSection(),
        BlocBuilder(
          bloc: BlocProvider.of<TransactionBloc>(context),
          builder: (BuildContext context, TransactionState state) {
            if (state is TransactionInitial) {
              return Text("test");
            } else if (state is TransactionLoading) {
              return CircularProgressIndicator();
            } else if (state is TransactionLoaded) {
              return Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: state.transactionList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return IconListTile(
                        tile: state.transactionList[index],
                      );
                    }),
              );
            }
            return Text("not working");
          },
        ),
      ],
    );
  }
}
