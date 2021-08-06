import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/account_event.dart';
import 'package:project_ez_finance/blocs/bloc/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  
  AccountBloc(AccountState initialState) : super(initialState);

  
  
  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is GetAccount) yield AccountLoaded();
  }

  
}