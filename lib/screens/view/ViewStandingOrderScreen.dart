import 'package:project_ez_finance/services/DateTimeFormatter.dart';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/models/StandingOrder.dart';
import 'package:project_ez_finance/models/currencies.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';
import '../../components/EmptyNotification.dart';
import '../../components/IconListTile.dart';
import '../../components/dialogs/ResponseDialog.dart';
class ViewStandingOrderScreen extends StatefulWidget {
  ViewStandingOrderScreen({Key? key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewStandingOrderScreen> {

  List<StandingOrder> _standingOrders = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late Future<List<StandingOrder>> futureStandingOrders;

  @override
  void initState() {
    super.initState();
    futureStandingOrders = HiveDatabase().getStandingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureStandingOrders,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        _standingOrders.clear();
        _standingOrders.addAll(snapshot.data as List<StandingOrder>);
        if (_standingOrders.isEmpty) return _standingOrdersEmptyNotification();
        return AnimatedList(
            key: _listKey,
            initialItemCount: _standingOrders.length,
            itemBuilder: (context, index, animation) 
              => _listBuilder(context, _standingOrders[index], animation)
          );
      }
    );
  }

  Widget _listBuilder (BuildContext context, StandingOrder standingOrder, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: IconListTile(
          selectable: false,
          onSelect: () => showStandingOrderMenu(context, standingOrder),
          onTap: () => showStandingOrderDetails(context, standingOrder),
          tile: standingOrder,
        )
      ),
    );
  }

  void showStandingOrderDetails(BuildContext context, StandingOrder standingOrder) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Text("Details"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name:"),
                Text("Starting date:"),
                Text("Next due date:"),
                Text("End date:"),
                Text("Total transactions:"),
                Text("Total amount:"),
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width / 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(standingOrder.initialTransaction.name),
                Text(standingOrder.initialTransaction.date.format()),
                Text(standingOrder.nextDueDate.format()),
                Text(standingOrder.initialTransaction.repetition.endDate!.format()),
                Text(standingOrder.totalTransactions.toString()),
                Text(_formatAmount(standingOrder.totalAmount)),
              ],
            )
          ],
        )
      )
    );
  }

  String _formatAmount(double amount) {
    return formatCurrency(
      HiveDatabase().selectedAccount!.currencyCode, 
      amount
    );

  }

  void showStandingOrderMenu(BuildContext context, StandingOrder standingOrder) {
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
              title: const Text("Show details"),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                showStandingOrderDetails(context, standingOrder);
              }
            ),
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

  void deleteStandingOrder(BuildContext context, StandingOrder standingOrder) async {
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
        bool noError = await HiveDatabase().deleteStandingOrder(standingOrder);
        if (noError) {
          futureStandingOrders = HiveDatabase().getStandingOrders();
          int index = _standingOrders.indexOf(standingOrder);
          _listKey.currentState!.removeItem(
            index, 
            (context, animation) => _listBuilder(context, standingOrder, animation)
          );
          _standingOrders.removeAt(index);
        } else {
          showDialog(
            context: context, 
            builder: (_) => ResponseDialog(
              description: "Problem occured while deleting this standing order. "+
              "Please try again!", 
              response: Response.Error
            )
          );
        }
      }
    }

  Widget _standingOrdersEmptyNotification() {
    return Center(child: EmptyNotification(
      title: "No standing orders available",
      information: 
        "Add new standing order by creating a new transaction" + 
        " and selecting the corresponding repetition.",
    ));
  }
}
