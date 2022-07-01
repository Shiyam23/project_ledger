import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/TextInputDialog.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:project_ez_finance/services/AdmobHelper.dart';
import 'ViewFilterBarViewDialog.dart';
import 'ViewFilterBarSortDialog.dart';
import 'ViewBarIcon.dart';

class ViewFilterBarSection extends StatefulWidget {
  final TransactionRequest request;
  const ViewFilterBarSection({Key? key, required TransactionRequest request})
      : request = request,
        super(key: key);

  _ViewFilterBarSectionState createState() => _ViewFilterBarSectionState();
}

class _ViewFilterBarSectionState extends State<ViewFilterBarSection> {
  late TransactionRequest _request;
  String? _searchText;
  TextEditingController _searchController = TextEditingController();
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _request = widget.request;
    _loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    double _paddingWidth = 20;
    double _width = (MediaQuery.of(context).size.width - _paddingWidth * 2) / 6;
    TransactionBloc bloc = BlocProvider.of<TransactionBloc>(context);
    return Column(
      children: <Widget>[
        AppBar(
          actions: <Widget>[
            SizedBox(width: _paddingWidth),
            StatefulBuilder(
              builder: (context, setState) {
                ValueNotifier<bool> showIndicator = ValueNotifier(false);
                return ViewBarIcon(
                  showIndicatorNotifier: showIndicator,
                  width: _width,
                  icon: Icons.search,
                  tooltip: "Search",
                  onTap: () async {
                    String? searchText = await showDialog(
                      context: context, 
                      builder: (context) => TextInputDialog(
                        prefixIcon: Icon(Icons.search),
                        controller: _searchController,
                        title: Text("Search"),
                      )
                    );
                    if (searchText != null) {
                      _searchText = searchText;
                      _request = _request.copyOf(searchText: _searchText);
                      bloc.add(GetTransaction(_request));
                    }
                    showIndicator.value = (
                      _searchText != null && _searchText != ""
                    );
                  },
                );
              }
            ),
            ViewBarIcon(
              width: _width,
              tooltip: "Date",
              icon: Icons.calendar_today,
              onTap: () async {
                DateTime start = DateTime.now().subtract(Duration(days: 365));
                DateTime end = DateTime.now().add(Duration(days: 365));
                DateTimeRange? dateRange = await showDateRangePicker(
                    context: context,
                    firstDate: start,
                    lastDate: end,
                    initialDateRange: _request.dateRange);
                if (dateRange != null) {
                  _request = _request.copyOf(
                    dateRange : DateTimeRange(
                      start: dateRange.start,
                      end: dateRange.end
                          .add(Duration(days: 1))
                          .subtract(Duration(microseconds: 1)))
                  );
                }
                bloc.add(GetTransaction(_request));
              },
            ),
            ViewBarIcon(
              width: _width,
              tooltip: "Viewmode",
              icon: Icons.list,
              onTap: () async {
                ViewMode? viewOption = await showDialog(
                  context: context,
                  builder: (context) {
                    return ViewFilterBarViewDialog(
                      initialOption: _request.viewMode
                    );
                  }
                );
                if (viewOption != null) _request = _request.copyOf(
                  viewMode: viewOption
                );
                bloc.add(GetTransaction(_request));
              },
            ),
            ViewBarIcon(
              width: _width,
              tooltip: "Sort",
              icon: Icons.sort,
              onTap: () async {
                SortMode? sortOption = await showDialog(
                  context: context,
                  builder: (context) {
                    return ViewFilterBarSortDialog(
                      initialOption: _request.sortMode
                    );
                  }
                );
                if (sortOption != null) {
                  _request = _request.copyOf(sortMode: sortOption);
                  bloc.add(GetTransaction(_request));
                }
              },
            ),
            ViewBarIcon(
              width: _width,
              tooltip: "Reset",
              icon: Icons.history,
              onTap: () async {
                final TransactionRequest request = TransactionRequest(
                  searchText: null,
                  viewMode: ViewMode.List,
                  timeMode: TimeMode.Individual,
                  sortMode: SortMode.DateAsc,
                  dateRange: DateTimeRange(
                  start: DateTime(DateTime.now().year, DateTime.now().month),
                  end: DateTime(DateTime.now().year, DateTime.now().month + 1)
                    .subtract(Duration(microseconds: 1)))
                );
                bloc.add(GetTransaction(request));
                setState(() {
                  _request = request;
                  _searchText = null;
                  _searchController.text = "";
                });
              },
            ),
            ViewBarIcon(
              tooltip: "Generate PDF",
              width: _width,
              icon: FontAwesomeIcons.filePdf,
              onTap: _showRewardedAd,
            ),
            SizedBox(width: _paddingWidth),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRewardedAd() async {
    await InterstitialAd.load(
      adUnitId: AdmobHelper.getInterstitialVideoId, 
      request: AdRequest(), 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print("Ok1");
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print("Ok2");
              ad.dispose();
            },
            onAdClicked: (ad) => print("Ok3"),
            onAdImpression: (ad) => print("Ok4"),
            onAdShowedFullScreenContent: (ad) => print("Ok5"),
            onAdWillDismissFullScreenContent: (ad) => print("Ok6")
          );
          _interstitialAd = ad;
        }, 
        onAdFailedToLoad: (ad) => print("Failed"),
      )
    );
  }

  void _showRewardedAd() async {
    _interstitialAd?.show();
  }
}

class ViewSelectionBarSection extends StatefulWidget {
  
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
  State<ViewSelectionBarSection> createState() => _ViewSelectionBarSectionState();
}

class _ViewSelectionBarSectionState extends State<ViewSelectionBarSection> {

  @override
  void initState() {
     super.initState();
  }
  @override
  
  Widget build(BuildContext context) {
    double _paddingWidth = 20;
    double _width = (MediaQuery.of(context).size.width - _paddingWidth * 2) / 6;
    return ValueListenableBuilder(
      valueListenable: widget.selectedTransactionsNotifier,
      builder: (context, numberSelected, _) {
        return AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.arrowLeft),
                onPressed: widget.onReset,
              ),
              SizedBox(width: 10),
              Text(
                " " + numberSelected.toString(),
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
                ),
              ),
              SizedBox(width: 10),
              Icon(FontAwesomeIcons.check)
            ],
          ),
          actions: <Widget>[
            SizedBox(width: _paddingWidth),
            if (numberSelected == 1) ViewBarIcon(
              width: _width,
              icon: Icons.edit,
              onTap: widget.onEdit,
            ),
            ViewBarIcon(
              width: _width,
              icon: Icons.delete_forever,
              onTap: widget.onDelete,
            ),
            ViewBarIcon(
              width: _width * 1.15,
              icon: Icons.delete_sweep,
              onTap: widget.onDeleteAll,
            ),
            SizedBox(width: _paddingWidth),
          ],
        );
      }
    );
  }
}
