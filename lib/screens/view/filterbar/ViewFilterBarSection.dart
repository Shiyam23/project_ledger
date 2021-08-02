import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'ViewFilterBarTimeDialog.dart';
import 'ViewFilterBarViewDialog.dart';
import 'ViewFilterBarSortDialog.dart';
import 'ViewFilterBarFilter.dart';
import 'ViewFilterBarIcon.dart';
import 'ViewFilterBarSearch.dart';

class ViewFilterBarSection extends StatefulWidget {
  ViewFilterBarSection({Key? key}) : super(key: key);

  _ViewFilterBarSectionState createState() => _ViewFilterBarSectionState();
}

class _ViewFilterBarSectionState extends State<ViewFilterBarSection> {
  bool _openSearchBar = false;
  bool _openFilterBar = false;

  ViewFilterBarTimeOptions? _timeOption;
  ViewFilterBarViewOptions? _viewOption;
  ViewFilterBarSortOptions? _sortOption;

  @override
  void initState() {
    super.initState();
    _timeOption = ViewFilterBarTimeOptions.individual;
    _viewOption = ViewFilterBarViewOptions.list;
    _sortOption = ViewFilterBarSortOptions.dateDown;
  }

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
              onTap: (open) => {
                BlocProvider.of<DatabaseBloc>(context).add(DeleteAll()),
                print("exporting ...")
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.list,
              onTap: (open) async {
                dynamic viewOption = await showDialog(
                    context: context,
                    builder: (context) {
                      return ViewFilterBarViewDialog(
                          initialOption: _viewOption);
                    });
                if (viewOption is ViewFilterBarViewOptions) {
                  setState(() {
                    _viewOption = viewOption;
                  });
                }
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.calendar_today,
              onTap: (open) async {
                dynamic timeOption = await showDialog(
                    context: context,
                    builder: (context) {
                      return ViewFilterBarTimeDialog(
                          initialOption: _timeOption);
                    });
                if (timeOption is ViewFilterBarTimeOptions) {
                  setState(() {
                    _timeOption = timeOption;
                  });
                }
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.sort,
              onTap: (open) async {
                dynamic sortOption = await showDialog(
                    context: context,
                    builder: (context) {
                      return ViewFilterBarSortDialog(
                          initialOption: _sortOption);
                    });
                if (sortOption is ViewFilterBarSortOptions) {
                  setState(() {
                    _sortOption = sortOption;
                  });
                }
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              isOpen: _openFilterBar,
              icon: Icons.monetization_on,
              onTap: (open) {
                setState(() {
                  _openFilterBar = open ?? false;
                });
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              isOpen: _openSearchBar,
              icon: Icons.search,
              onTap: (open) {
                setState(() {
                  _openSearchBar = open ?? false;
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
