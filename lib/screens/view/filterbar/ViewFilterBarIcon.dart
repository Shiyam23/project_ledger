import 'package:flutter/material.dart';

class ViewFilterBarIcon extends StatefulWidget {
  ViewFilterBarIcon({
    Key key,
    @required this.width,
    @required this.icon,
    this.onTap,
    this.canOpen = true,
    this.isOpen = false,
  }) : super(key: key);

  final double width;
  final IconData icon;
  final bool canOpen;
  final ValueChanged<bool> onTap;
  final bool isOpen;

  _ViewFilterBarIconState createState() => _ViewFilterBarIconState();
}

class _ViewFilterBarIconState extends State<ViewFilterBarIcon> {
  bool _open;

  @override
  void initState() {
    super.initState();
    _open =widget.isOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(widget.icon, size: widget.width / 2),
              widget.canOpen
                  ? Center(
                      child: Icon(
                          _open ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: widget.width / 3))
                  : Container(),
            ],
          ),
          onTap: () {
            if (widget.canOpen)
              setState(() {
                _open = !_open;
              });
            if (widget.onTap != null) widget.onTap(_open);
          }),
    );
  }
}
