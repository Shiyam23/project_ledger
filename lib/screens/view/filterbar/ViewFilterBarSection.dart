import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'ViewFilterBarTimeDialog.dart';
import 'ViewFilterBarViewDialog.dart';
import 'ViewFilterBarSortDialog.dart';
import 'ViewFilterBarFilter.dart';
import 'ViewFilterBarIcon.dart';
import 'ViewFilterBarSearch.dart';

class ViewFilterBarSection extends StatefulWidget {
  final TransactionRequest request;
  ViewFilterBarSection({Key? key, required TransactionRequest request})
      : request = request,
        super(key: key);

  _ViewFilterBarSectionState createState() => _ViewFilterBarSectionState();
}

class _ViewFilterBarSectionState extends State<ViewFilterBarSection> {
  bool _openSearchBar = false;
  bool _openFilterBar = false;

  TimeMode? _timeOption;
  ViewMode? _viewOption;
  SortMode? _sortOption;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _timeOption = widget.request.timeMode;
    _viewOption = widget.request.viewMode;
    _sortOption = widget.request.sortMode;
    _dateRange = widget.request.dateRange;
  }

  @override
  Widget build(BuildContext context) {
    double _paddingWidth = 20;
    double _width = (MediaQuery.of(context).size.width - _paddingWidth * 2) / 6;

    return Column(
      children: <Widget>[
        AppBar(
          actions: <Widget>[
            SizedBox(width: _paddingWidth),
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
            ViewFilterBarIcon(
              width: _width,
              icon: Icons.calendar_today,
              canOpen: false,
              onTap: (open) async {
                DateTime start = DateTime.now().subtract(Duration(days: 365));
                DateTime end = DateTime.now().add(Duration(days: 365));
                _dateRange = await showDateRangePicker(
                    context: context,
                    firstDate: start,
                    lastDate: end,
                    initialDateRange: widget.request.dateRange);
                if (_dateRange != null) {
                  _dateRange = DateTimeRange(
                      start: _dateRange!.start,
                      end: _dateRange!.end
                          .add(Duration(days: 1))
                          .subtract(Duration(microseconds: 1)));
                  widget.request.dateRange = _dateRange!;
                }
                BlocProvider.of<TransactionBloc>(context)
                    .add(GetTransaction(widget.request));
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
                if (viewOption is ViewMode) {
                  setState(() {
                    _viewOption = viewOption;
                  });
                }
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.compress,
              onTap: (open) async {
                dynamic timeOption = await showDialog(
                    context: context,
                    builder: (context) {
                      return ViewFilterBarTimeDialog(
                          initialOption: _timeOption);
                    });
                if (timeOption is TimeMode) {
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
                if (sortOption is SortMode) {
                  setState(() {
                    _sortOption = sortOption;
                  });
                }
              },
            ),
            ViewFilterBarIcon(
              width: _width,
              canOpen: false,
              icon: Icons.file_upload,
              onTap: (open) => {
                BlocProvider.of<TransactionBloc>(context).add(DeleteAll()),
              },
            ),
            SizedBox(width: _paddingWidth),
          ],
        ),
        _openSearchBar
            ? ViewFilterBarSearch(request: widget.request)
            : Container(),
        _openFilterBar ? ViewFilterBarFilter() : Container(),
      ],
    );
  }
}
