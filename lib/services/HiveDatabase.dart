import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';

import 'Database.dart';

class HiveDatabase implements Database {

  const HiveDatabase();

  @override
  Future<List<Account>> getAllAccounts() async{
    Box? accountBox = await Hive.openBox("accounts");
    List<Account> result = [];
    accountBox.values.forEach((e) => result.add(e));
    return Future.value(result);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    Box? catgoryBox = await Hive.openBox("categories");
    /* List<Category> result = List.filled(30, 
      Category(
        name: "Haus",
        icon: CategoryIcon(
          iconData: CategoryIconData(
            iconName: "home"
          )
        )
      )
    ); */
    List<Category> result = [];
    catgoryBox.values.forEach((e) => result.add(e));
    return Future.value(result);
  }

  
}