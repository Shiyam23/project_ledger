import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';

class ViewFilterBarSearch extends StatelessWidget {
  final TransactionRequest request;
  const ViewFilterBarSearch({Key? key, required TransactionRequest request})
      : request = request,
        super(key: key);

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
                TransactionBloc bloc = BlocProvider.of<TransactionBloc>(context);
                request.searchText = string;
                bloc.add(GetTransaction(request));
              },
            ),
          ),
        ),
      ],
    );
  }
}
