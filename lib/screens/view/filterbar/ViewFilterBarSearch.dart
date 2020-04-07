import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction_event.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';

class ViewFilterBarSearch extends StatelessWidget {
  const ViewFilterBarSearch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              onSubmitted: (string) {
                TransactionBloc bloc =
                    BlocProvider.of<TransactionBloc>(context);
                bloc.filter.searchText = string;
                bloc.dispatch(GetTransaction());
              },
            ),
          ),
        ),
      ],
    );
  }
}
