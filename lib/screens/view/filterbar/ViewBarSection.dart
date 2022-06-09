import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'ViewFilterBarTimeDialog.dart';
import 'ViewFilterBarViewDialog.dart';
import 'ViewFilterBarSortDialog.dart';
import 'ViewFilterBarFilter.dart';
import 'ViewBarIcon.dart';
import 'ViewFilterBarSearch.dart';

class ViewFilterBarSection extends StatefulWidget {
  final TransactionRequest request;
  const ViewFilterBarSection({Key? key, required TransactionRequest request})
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
            ViewBarIcon(
              width: _width,
              icon: Icons.search,
            ),
            ViewBarIcon(
              width: _width,
              icon: Icons.calendar_today,
              onTap: () async {
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
            ViewBarIcon(
              width: _width,
              icon: Icons.list,
              onTap: () async {
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
            ViewBarIcon(
              width: _width,
              icon: Icons.compress,
              onTap: () async {
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
            ViewBarIcon(
              width: _width,
              icon: Icons.sort,
              onTap: () async {
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
            ViewBarIcon(
              width: _width,
              icon: Icons.file_upload,
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

class ViewSelectionBarSection extends StatelessWidget {
  
  final void Function() onDelete;
  final void Function() onDeleteAll;
  final void Function() onEdit;
  final void Function() onReset;
  final ValueNotifier<int> selectedTransactionsNotifier;
  
  const ViewSelectionBarSection({
    Key? key,
    required this.onDelete,
    required this.onDeleteAll,
    required this.onEdit,
    required this.onReset,
    required this.selectedTransactionsNotifier
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _paddingWidth = 20;
    double _width = (MediaQuery.of(context).size.width - _paddingWidth * 2) / 6;
    return AppBar(
      title: Row(
        children: [
          IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: onReset,
          ),
          SizedBox(width: 10),
          ValueListenableBuilder(
                valueListenable: selectedTransactionsNotifier, 
                builder: (context, numberSelected, _) {
                  return Text(
                    " " + numberSelected.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  );
                }
          ),
          SizedBox(width: 10),
          Icon(FontAwesomeIcons.check)
        ],
      ),
      actions: <Widget>[
        SizedBox(width: _paddingWidth),
        ViewBarIcon(
          width: _width,
          icon: Icons.edit,
          onTap: onEdit,
        ),
        ViewBarIcon(
          width: _width,
          icon: Icons.delete_forever,
          onTap: onDelete,
        ),
        ViewBarIcon(
          width: _width * 1.15,
          icon: Icons.delete_sweep,
          onTap: onDeleteAll,
        ),
        SizedBox(width: _paddingWidth),
      ],
    );
  }
}
