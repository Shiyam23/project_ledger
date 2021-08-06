import 'package:equatable/equatable.dart';
import 'package:project_ez_finance/models/Account.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
}


class AddAccount extends AccountEvent {
  final Account account;

  AddAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class GetAccount extends AccountEvent {
  GetAccount();

  @override
  List<Object?> get props => [];
}