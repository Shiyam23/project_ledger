import 'package:flutter/material.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';

import '../../components/IconListTile.dart';

class ViewStandingOrderScreen extends StatefulWidget {
  ViewStandingOrderScreen({Key? key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewStandingOrderScreen> {

  List<Transaction> _standingOrders = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HiveDatabase().getStandingOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        _standingOrders.clear();
        _standingOrders.addAll(snapshot.data as List<Transaction>);
        return AnimatedList(
            key: _listKey,
            initialItemCount: _standingOrders.length,
            itemBuilder: (context, index, animation) 
              => _listBuilder(context, _standingOrders[index], animation)
          );
      }
    );
  }

  Widget _listBuilder (BuildContext context, Transaction standingOrder, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: IconListTile(
          selectable: false,
          onSelect: () => showStandingOrderMenu(context, standingOrder),
          onTap: () => showStandingOrderMenu(context, standingOrder),
          tile: standingOrder,
        )
      ),
    );
  }

  void showStandingOrderMenu(BuildContext context, Transaction standingOrder) {
    showModalBottomSheet(context: context, builder: (sheetContext) {
      return SafeArea(
        bottom: true,
        left: false,
        top: false,
        right: false,
        child: Wrap(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: const Text("Delete standing order"),
              leading: const Icon(Icons.delete),
              onTap: () => deleteStandingOrder(context, standingOrder)
            ),
          ]
        ),
      );
    });    
  }

  void deleteStandingOrder(BuildContext context, Transaction standingOrder) async {
      Navigator.of(context).pop();
      bool? sureToDelete = await showDialog<bool>(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Delete standing Order?"),
          content: const Text(
            "Are you sure that you want to delete this standing order? " + 
            "Transactions added by this standing order will not be deleted.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel")
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete")
            ),
          ],
        ));
      if (sureToDelete ?? false) {
        bool noError = await HiveDatabase().deleteRepetition(standingOrder);
        if (noError) {
          int index = _standingOrders.indexOf(standingOrder);
          _listKey.currentState!.removeItem(
            index, 
            (context, animation) => _listBuilder(context, standingOrder, animation)
          );
          _standingOrders.removeAt(index);
        } else {
          print("Error occurred while deleting Template");
          //TODO: show proper error message
        }
      }
    }
}
