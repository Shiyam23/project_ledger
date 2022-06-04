import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_ez_finance/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmountController.dart';

class KeyboardWidget extends InheritedWidget {

  final KeyBoard keyboard;
  final void Function(bool open) triggerKeyboard;
  final Widget child;

  KeyboardWidget({
    required this.keyboard,
    required this.triggerKeyboard,
    required this.child
  }) : 
  super(child: child);

  static KeyboardWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeyboardWidget>();
  }

  @override
  bool updateShouldNotify(KeyboardWidget oldWidget) {
    return false;
  }
}

class KeyBoard extends StatefulWidget {

  final void Function(bool open) triggerKeyboard;

  const KeyBoard({
    Key? key,
    required this.triggerKeyboard
  }) : super(key: key);

  @override
  State<KeyBoard> createState() => KeyBoardState();
}

class KeyBoardState extends State<KeyBoard> with SingleTickerProviderStateMixin{

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  late final double width = MediaQuery.of(context).size.width;
  late final double height = MediaQuery.of(context).size.height;

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(_animationController);

  NewMoneyAmountController? amountController = NewMoneyAmountController.instance;

  @override
  void initState() { 
    super.initState();
    _animationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    Size buttonSize = Size(this.width/4 - 5, this.height/12 - 5);
    double height = MediaQuery.of(context).size.height / 3;
    return TextButtonTheme(
      data: TextButtonThemeData(
        style: TextButton.styleFrom(
          enableFeedback: true,
          backgroundColor: Colors.white,
          fixedSize: buttonSize,
          elevation: 5,
          textStyle: TextStyle(fontSize: height/8),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        )
      ),
      child: SlideTransition(
        position: _offsetAnimation,
        child: WillPopScope(
          onWillPop: () {
            closeKeyboard();
            return Future.value(false);
          },
          child: Container(
            color: Theme.of(context).primaryColor,
            height: height,
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
                      width: buttonSize.width,
                      height: buttonSize.height
                    ), 
                  ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(
                      child: Text("2"),
                      onPressed: () => tapButton("2")
                    ), 
                    TextButton(
                      child: Text("5"),
                      onPressed: () => tapButton("5")
                    ), 
                    TextButton(
                      child: Text("8"),
                      onPressed: () => tapButton("8")
                    ), 
                    TextButton(
                      child: Text("0"),
                      onPressed: () => tapButton("0")
                    ), 
                  ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text("3"),
                      onPressed: () => tapButton("3")
                    ), 
                    TextButton(
                      child: Text("6"),
                      onPressed: () => tapButton("6")
                    ), 
                    TextButton(
                      child: Text("9"),
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
                      child: Text(
                        "+ / -",
                        style: TextStyle(
                          inherit: true,
                          color: Colors.black 
                        ),
                      ),
                      onPressed: () => tapButton("+ / -"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "OK",
                        style: TextStyle(
                          inherit: true,
                          color: Colors.black 
                        ),
                      ),
                      onPressed: closeKeyboard,
                      style: TextButton.styleFrom(
                        fixedSize: _getOKSize(buttonSize, height),
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
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void closeKeyboard() {
    _animationController.reverse().then(
      (value) => widget.triggerKeyboard(false)
    );
    FocusScope.of(context).unfocus();
  }

  void tapButton(String key) {
    HapticFeedback.mediumImpact();
    amountController?.press(key);
  }

  Size _getOKSize(Size buttonSize, double height) {
    double space = (height - (4 * buttonSize.height)) / 5;
    return Size(buttonSize.width, buttonSize.height * 2 + space);
  }
}