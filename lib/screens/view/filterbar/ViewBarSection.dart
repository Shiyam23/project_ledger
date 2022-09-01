import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/dialogs/LoadingDialog.dart';
import 'package:project_ez_finance/components/dialogs/ResponseDialog.dart';
import 'package:project_ez_finance/components/dialogs/TextInputDialog.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:project_ez_finance/services/AdmobHelper.dart';
import 'package:project_ez_finance/services/PDFGenerator.dart';
import 'ViewFilterBarViewDialog.dart';
import 'ViewFilterBarSortDialog.dart';
import 'ViewBarIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  tooltip: AppLocalizations.of(context)!.search,
                  onTap: () async {
                    String? searchText = await showDialog(
                      context: context, 
                      builder: (context) => TextInputDialog(
                        prefixIcon: Icon(Icons.search),
                        controller: _searchController,
                        title: Text(AppLocalizations.of(context)!.search),
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
              tooltip: AppLocalizations.of(context)!.date,
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
              tooltip: AppLocalizations.of(context)!.view_mode,
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
              tooltip: AppLocalizations.of(context)!.sort,
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
              tooltip: AppLocalizations.of(context)!.reset,
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
              tooltip: AppLocalizations.of(context)!.create_invoice,
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
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _showRewardedAd() async {
    if (_interstitialAd == null) {
      LoadingProgress adloadingProgress = LoadingProgress();
      showDialog(
        context: context, 
        builder: (context) => LoadingDialog(
          loadingProgress: adloadingProgress, 
          title: AppLocalizations.of(context)!.loading_ad
        )
      );
      await Future.doWhile(() {
        return Future.delayed(
          Duration(milliseconds: 100), 
          () => Future.value(_interstitialAd == null)
        );
      });
      Navigator.pop(context);
    }
    _interstitialAd?.show();
    _loadRewardedAd();
  }

  Future<void> _loadRewardedAd() async {
    await InterstitialAd.load(
      adUnitId: AdmobHelper.getInterstitialVideoId, 
      request: AdRequest(), 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _generatePDF();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _generatePDF();
            }
          );
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) => _generatePDF(),
      )
    );
  }

  void _generatePDF() async {
    final LoadingProgress loadingProgress = LoadingProgress();
    showDialog(
      context: context, 
      builder: (context) => LoadingDialog(
        loadingProgress: loadingProgress, 
        title: AppLocalizations.of(context)!.generating_invoice,
      ),
      barrierDismissible: false
    );
    TransactionState state = BlocProvider.of<TransactionBloc>(context).state;
    if (state is TransactionLoaded) {
      if (state.transactionList.isNotEmpty) {
        Invoice invoice = Invoice(
        transactions: state.transactionList, 
        color: Theme.of(context).primaryColor,
        );
        await invoice.openInvoice(context);
        loadingProgress.initialize(1);
        loadingProgress.forward();
        loadingProgress.finish();
      }
      else {
        Navigator.of(context).pop();
        showDialog(
          context: context, 
          builder: (context) => ResponseDialog(
            description: AppLocalizations.of(context)!.list_empty, 
            response: Response.Error
          )
        );
      }
      
    }
    else {
      Navigator.of(context).pop();
      showDialog(
        context: context, 
        builder: (context) => ResponseDialog(
          description: AppLocalizations.of(context)!.something_went_wrong, 
          response: Response.Error
        )
      );
    }
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
      builder: (context, int numberSelected, _) {
        return AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.arrowLeft),
                onPressed: widget.onReset,
              ),
              SizedBox(width: 5),
              Text(
                " " + (numberSelected == 0 ? 1 : numberSelected).toString(),
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
                ),
              ),
              SizedBox(width: 5),
              Icon(FontAwesomeIcons.check)
            ],
          ),
          actions: <Widget>[
            SizedBox(width: _paddingWidth),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: getEditButton(_width, numberSelected),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
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

  Widget getEditButton(double width, int selectedTransactions) {
    if (selectedTransactions == 1) {
      return ViewBarIcon(
        width: width,
        icon: Icons.edit,
        onTap: widget.onEdit,
      );
    } else {
      return SizedBox(width: width);
    }
    
  }
}
