import 'package:flutter/material.dart';

abstract class DTheme {

  ThemeData get td;
  
  TextStyle get inivisText;

  ////////////////////////////////////////////////////////////////

  static DTheme of(BuildContext context) {
    return _getInheritedDTheme(context)?.dTheme;
  }

  static void switchTheme(
      {@required BuildContext context, @required DTheme newDTheme}) {
    _getInheritedDTheme(context)?.onDThemeChanged(newDTheme);
  }

  static _InheritedDTheme _getInheritedDTheme(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_InheritedDTheme)
          as _InheritedDTheme;
}

class DThemeContainer extends StatefulWidget {
  DThemeContainer({
    Key key,
    @required this.initialDTheme,
    @required this.child,
  }) : super(key: key);

  final DTheme initialDTheme;
  final Widget child;

  _DThemeContainerState createState() => _DThemeContainerState();
}

class _DThemeContainerState extends State<DThemeContainer> {
  DTheme _dTheme;

  @override
  void initState() {
    _dTheme = widget.initialDTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedDTheme(
      dTheme: _dTheme,
      child: widget.child,
      onDThemeChanged: onDThemeChanged,
    );
  }

  void onDThemeChanged(DTheme newDTheme) {
    setState(() {
      _dTheme = newDTheme;
    });
  }
}

class _InheritedDTheme extends InheritedWidget {
  _InheritedDTheme({
    Key key,
    @required this.dTheme,
    @required this.onDThemeChanged,
    @required Widget child,
  }) : super(key: key, child: child);

  final DTheme dTheme;
  final ValueChanged<DTheme> onDThemeChanged;

  @override
  bool updateShouldNotify(_InheritedDTheme old) {
    return dTheme.runtimeType != old.dTheme.runtimeType;
  }
}
