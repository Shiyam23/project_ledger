import 'package:dollavu/components/dialogs/ConfirmDialog.dart';
import 'package:dollavu/services/DateTimeFormatter.dart';
import 'package:flutter/material.dart';
import 'package:dollavu/models/StandingOrder.dart';
import 'package:dollavu/models/currencies.dart';
import 'package:dollavu/services/HiveDatabase.dart';
import '../../components/EmptyNotification.dart';
import '../../components/IconListTile.dart';
import '../../components/dialogs/ResponseDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.repetition_details_title),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.repetition_name),
                Text(AppLocalizations.of(context)!.repetition_starting_date),
                Text(AppLocalizations.of(context)!.repetition_next_due_date),
                Text(AppLocalizations.of(context)!.repetition_end_date),
                Text(AppLocalizations.of(context)!.repetition_total_transactions),
                Text(AppLocalizations.of(context)!.repetition_total_amount),
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
              title: Text(AppLocalizations.of(context)!.repetition_show_details),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                showStandingOrderDetails(context, standingOrder);
              }
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: Text(AppLocalizations.of(context)!.repetition_delete),
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
        builder: (context) => ConfirmDeleteDialog(
          title: AppLocalizations.of(context)!.repetition_delete_title,
          content: AppLocalizations.of(context)!.repetition_delete_description
        )
      );
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
          if (_standingOrders.isEmpty) setState(() {});
        } else {
          showDialog(
            context: context, 
            builder: (_) => ResponseDialog(
              description: AppLocalizations.of(context)!.repetition_delete_error_description, 
              response: Response.Error
            )
          );
        }
      }
    }

  Widget _standingOrdersEmptyNotification() {
    return Center(child: EmptyNotification(
      title: AppLocalizations.of(context)!.no_repetition_available,
      information: AppLocalizations.of(context)!.no_repetition_available_description
    ));
  }
}
