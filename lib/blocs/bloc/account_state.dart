import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';

abstract class AccountState {
  const AccountState();
}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<Account> accountList;
  AccountLoaded()
      : accountList = [
          Account(
              name: "Privatkonto",
              icon: CategoryIcon(
                iconData: CategoryIconData(
                  iconName: "home",
                  iconColorInt: Colors.white.value,
                ),
              )),
          Account(
              name: "Geschäftskonto",
              icon: CategoryIcon(
                iconData: CategoryIconData(
                  iconName: "suitcaseRolling",
                  iconColorInt: Colors.white.value,
                ),
              ))
        ];
}