import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:project_ez_finance/components/Keyboard.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'NewMoneyAmountController.dart';

class NewMoneyAmount extends StatefulWidget {

  static final GlobalKey<State<NewMoneyAmount>> globalKey = GlobalKey<State<NewMoneyAmount>>();

  NewMoneyAmount() : 
  super(key: globalKey);

  @override
  _NewMoneyAmountState createState() => _NewMoneyAmountState();

}

class _NewMoneyAmountState extends State<NewMoneyAmount> {
  
  NewMoneyAmountController controller = NewMoneyAmountController.instance;
  late final TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);
  double fontSizeFactor = 0.15;
  Account? selectedAccount;
  bool? isExpenseDifferent;
  bool? accountDifferent;
  bool? amountDifferent;

  @override
  void initState() {
    controller.setSign = setSign;
    controller.updateFontSize = updateFontSize;
    controller.buildInitialText(0);
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
        return accountDifferent! || amountDifferent! || isExpenseDifferent! || !controller.initialized;
      },
      listener: (context, state) {
        if (accountDifferent! || !controller.initialized) {
          selectedAccount = state.account!;
          controller.setupController(
            selectedAccount!,
            state.amount
          );
        }
        if (amountDifferent!) {
          controller.buildInitialText(state.amount);
          controller.updateThousandseparator(-1);
        }
        setSign(state.isExpense!);
      },
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20, bottom: 50),
          decoration: BoxDecoration(
            boxShadow: [
                BoxShadow(
                  offset: Offset(5,5),
                  blurRadius: 5,
                  color: Colors.black26
                )
            ],
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            color: Theme.of(context).primaryColor,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextField(
              controller: controller,
              readOnly: true,
              cursorWidth: 3,
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
                suffixStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 
                    MediaQuery.of(context).size.height 
                    * fontSizeFactor * 0.49
                    * MediaQuery.of(context).textScaleFactor
                ),
                suffixText: getSuffix(),
                prefixText: getPrefix(),
                prefixStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 
                    MediaQuery.of(context).size.height 
                    * fontSizeFactor * 0.49
                    * MediaQuery.of(context).textScaleFactor
                ),
              ),
              cursorColor: Colors.white,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 
                  MediaQuery.of(context).size.height 
                  * fontSizeFactor * 0.49
                  * MediaQuery.of(context).textScaleFactor
                  ,
              ),
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
      cubit.projectDetails(details);
    }
    setState(() => controller.isExpense = isExpense);
  } 

  String? getSuffix() {
    if (controller.symbolOnLeft != null) {
      return controller.symbolOnLeft! ? null : controller.symbol;
    }
    return null;
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
    return null;
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
