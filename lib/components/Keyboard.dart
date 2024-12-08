import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dollavu/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmountController.dart';

bool showingKeyboard = false;

showKeyboard(BuildContext context) {
  if (!showingKeyboard) {
    showingKeyboard = true;
    Navigator.of(context).push(KeyBoard());
  }
}

hideKeyboard(BuildContext context) {
  if (showingKeyboard) {
    showingKeyboard = false;
    Navigator.of(context).pop();
    FocusScope.of(context).unfocus();
  }
}

class KeyBoard extends TransitionRoute {
  
  NewMoneyAmountController? amountController = NewMoneyAmountController.instance;
  Tween<Offset> slideOffset = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  );

  late CurvedAnimation easeAnimation = CurvedAnimation(
    parent: animation!, 
    curve: Curves.ease
  );

  Size? buttonSize;
  double? dialogHeight;
  Size? okButtonSize;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double? height = MediaQuery.of(context).size.height;
    buttonSize ??= Size(width/4 - (height / 300), height/12 - (height / 200));
    dialogHeight ??= height / 3;
    okButtonSize ??= _getOKSize(buttonSize!, dialogHeight!);
    return Container(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        bottom: true,
        left: false,
        top: false,
        right: false,
        child: TextButtonTheme(
          data: TextButtonThemeData(
            style: TextButton.styleFrom(
              enableFeedback: true,
              backgroundColor: Colors.white,
              fixedSize: buttonSize,
              elevation: 5,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: TextStyle(fontSize: dialogHeight!/8),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            )
          ),
          child: WillPopScope(
            onWillPop: () {
              hideKeyboard(context);
              return Future.value(false);
            },
            child: SlideTransition(
              position: slideOffset.animate(easeAnimation),
              child: Container(
                color: Theme.of(context).primaryColor,
                height: dialogHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text("1"),
                          onPressed: () => tapButton("1"),
                        ),
                        TextButton(
                          child: Text("4"),
                          onPressed: () => tapButton("4"),
                        ), 
                        TextButton(
                          child: Text("7"),
                          onPressed: () => tapButton("7"),
                        ), 
                        SizedBox(
                          width: buttonSize!.width,
                          height: buttonSize!.height
                        ), 
                      ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                          child: const Text("2"),
                          onPressed: () => tapButton("2")
                        ), 
                        TextButton(
                          child: const Text("5"),
                          onPressed: () => tapButton("5")
                        ), 
                        TextButton(
                          child: const Text("8"),
                          onPressed: () => tapButton("8")
                        ), 
                        TextButton(
                          child: const Text("0"),
                          onPressed: () => tapButton("0")
                        ), 
                      ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: const Text("3"),
                          onPressed: () => tapButton("3")
                        ), 
                        TextButton(
                          child: const Text("6"),
                          onPressed: () => tapButton("6")
                        ), 
                        TextButton(
                          child: const Text("9"),
                          onPressed: () => tapButton("9")
                        ),
                        TextButton(
                          child: Text(amountController!.decimalSeparator!),
                          onPressed: () => tapButton(amountController!.decimalSeparator!)
                        ), 
                      ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Icon(Icons.backspace, color: Colors.white,),
                          onPressed: () => tapButton("Backspace"),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red                        
                          ),
                        ), 
                        TextButton(
                          child: const Text(
                            "+ / -",
                            style: TextStyle(
                              inherit: true,
                            ),
                          ),
                          onPressed: () => tapButton("+ / -"),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white
                          ),
                        ),
                        TextButton(
                          child: Text(
                            MaterialLocalizations.of(context).okButtonLabel,
                            style: TextStyle(
                              inherit: true,
                            ),
                          ),
                          onPressed: () {
                            hideKeyboard(context);
                          },
                          style: TextButton.styleFrom(
                            fixedSize: okButtonSize,
                            backgroundColor: Colors.white
                          ),
                        ), 
                      ]
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

  void tapButton(String key) {
    HapticFeedback.mediumImpact();
    amountController?.press(key);
  }

  Size _getOKSize(Size buttonSize, double height) {
    double space = (height - (4 * buttonSize.height)) / 5;
    return Size(buttonSize.width, buttonSize.height * 2 + space);
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [OverlayEntry(builder: build)];
  }

  @override
  bool get opaque => false;

  @override
  bool get willDisposeAnimationController => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);

  @override
  // TODO: implement popGestureEnabled
  bool get popGestureEnabled => throw UnimplementedError();
}
