import 'package:flutter/material.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarFilter.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarIcon.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarSearch.dart';

class ViewFilterBarSection extends StatefulWidget {
  ViewFilterBarSection({Key key}) : super(key: key);

  _ViewFilterBarSectionState createState() => _ViewFilterBarSectionState();
}

class _ViewFilterBarSectionState extends State<ViewFilterBarSection> {
  bool _openSearchBar = false;
  bool _openFilterBar = false;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width / 6;

    return Column(
      children: <Widget>[
        AppBar(
          actions: <Widget>[
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.file_upload,
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.format_align_left,
              onTap: (open) async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text("TITLE"),
                        children: <Widget>[
                          Divider(thickness: 2.0),
                          Center(
                            child: Text("body"),
                          ),
                        ],
                      );
                    });
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.calendar_today,
              onTap: (open) async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text("TITLE"),
                        children: <Widget>[
                          Divider(thickness: 2.0),
                          Center(
                            child: Text("body"),
                          ),
                        ],
                      );
                    });
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.sort,
              onTap: (open) async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text("TITLE"),
                        children: <Widget>[
                          Divider(thickness: 2.0),
                          Center(
                            child: Text("body"),
                          ),
                        ],
                      );
                    });
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              isOpen: _openFilterBar,
              icon: Icons.monetization_on,
              onTap: (open) {
                setState(() {
                  _openFilterBar = open;
                });
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              isOpen: _openSearchBar,
              icon: Icons.search,
              onTap: (open) {
                setState(() {
                  _openSearchBar = open;
                });
              },
            ),
          ],
        ),
        _openSearchBar ? ViewFilterBarSearch() : Container(),
        _openFilterBar ? ViewFilterBarFilter() : Container(),
      ],
    );
  }
}
