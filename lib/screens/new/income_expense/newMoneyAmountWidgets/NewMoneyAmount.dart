import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:project_ez_finance/components/Keyboard.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'NewMoneyAmountController.dart';

class NewMoneyAmount extends StatefulWidget {

  final void Function(NewMoneyAmountController controller) setController;
  static final GlobalKey<State<NewMoneyAmount>> globalKey = GlobalKey<State<NewMoneyAmount>>();

  NewMoneyAmount({
    required this.setController, 
  }) : 
  super(key: globalKey);

  @override
  _NewMoneyAmountState createState() => _NewMoneyAmountState();

}

class _NewMoneyAmountState extends State<NewMoneyAmount> {
  
  late NewMoneyAmountController controller;
  late final TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);
  double fontSizeFactor = 0.15;
  Account? selectedAccount;
  bool? isExpenseDifferent;
  bool? accountDifferent;
  bool? amountDifferent;

  @override
  void initState() {
    controller = NewMoneyAmountController(initialString: "0,00");
    widget.setController(controller);
    controller.setSign = setSign;
    controller.updateFontSize = updateFontSize;
    super.initState();
  }

  void updateFontSize(int textLength) {
    if (textLength > 14) {
      if (this.fontSizeFactor != 0.0825) {
        setState(() => this.fontSizeFactor = 0.0825);
      }
      return;
    }
    if (textLength > 11) {
      if (this.fontSizeFactor != 0.1) {
        setState(() => this.fontSizeFactor = 0.1);
      }
      return;
    }
    if (textLength > 9) {
      if (this.fontSizeFactor != 0.125) {
        setState(() => this.fontSizeFactor = 0.125);
      }
      return;
    } 
    if (textLength <= 9) {
      if (this.fontSizeFactor != 0.15) {
        setState(() => this.fontSizeFactor = 0.15);
      }
      return;
    } 
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionDetailsCubit, TransactionDetails>(
      listenWhen: (p,c) {
        this.accountDifferent = c.account != null && c.account != p.account;
        this.amountDifferent = c.amount != p.amount;
        this.isExpenseDifferent = c.isExpense != p.isExpense;
        return accountDifferent! || amountDifferent! || isExpenseDifferent!;
      },
      listener: (context, state) {
        if (accountDifferent!) {
          selectedAccount = state.account!;
          controller.setupController(
            selectedAccount!,
            state.amount
          );
        }
        else if (amountDifferent!) {
          controller.buildInitialText(state.amount);
          controller.updateThousandseparator(-1);
        }
        if (isExpenseDifferent! ) setSign(state.isExpense!);
      },
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height / 7,
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            readOnly: true,
            showCursor: true,
            enableInteractiveSelection: true,
            onTap: () => KeyboardWidget.of(context)?.triggerKeyboard(true),
            toolbarOptions: ToolbarOptions(
              copy: true,
              cut: false,
              paste: false,
              selectAll: true
            ),
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              suffixText: getSuffix(),
              prefixText: getPrefix(),
            ),
            cursorColor: Theme.of(context).colorScheme.primary,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey[900],
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.width * fontSizeFactor,
            ),
          ),
        );
      }
    );
  }

  void setSign(bool isExpense) {
    if (controller.isExpense != isExpense) {
      TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);
      TransactionDetails details = cubit.state.copyWith(
        isExpense: isExpense
      );
      cubit.emit(details);
    }
    setState(() => controller.isExpense = isExpense);
  } 

  String? getSuffix() {
    if (controller.symbolOnLeft != null)
    return controller.symbolOnLeft! ? null : controller.symbol;
  }

  String? getPrefix() {
    if (
      controller.symbolOnLeft != null &&
      controller.spaceBetweenAmountAndSymbol != null &&
      controller.symbol != null
    ) {
      bool spaceBetweenSymbol = controller.spaceBetweenAmountAndSymbol!;
      String sign = controller.isExpense ? "−" : "+";
      String space = spaceBetweenSymbol ? " " : "";
      String symbol = controller.symbol!;
      if (controller.symbolOnLeft!) return "$sign $symbol$space";
      else return sign;
    }
  }

  @override
  void didChangeDependencies() {
    
    super.didChangeDependencies();
    
  }

  @override
  void dispose() {
    super.dispose();
  }
  
}
