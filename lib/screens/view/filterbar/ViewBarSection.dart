import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dollavu/blocs/bloc/bloc.dart';
import 'package:dollavu/components/CategorySelectionSheet.dart';
import 'package:dollavu/components/dialogs/LoadingDialog.dart';
import 'package:dollavu/components/dialogs/ResponseDialog.dart';
import 'package:dollavu/components/dialogs/TextInputDialog.dart';
import 'package:dollavu/models/Modes.dart';
import 'package:dollavu/services/AdmobHelper.dart';
import 'package:dollavu/services/PDFGenerator.dart';
import '../../../models/Category.dart';
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
  bool adFailedToLoad = false;
  ValueNotifier<bool> showSearchIndicator = ValueNotifier(false);
  ValueNotifier<bool> showCategoryIndicator = ValueNotifier(false);

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
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20)
        )
      ),
      actions: <Widget>[
        SizedBox(width: _paddingWidth),
        ViewBarIcon(
          showIndicatorNotifier: showSearchIndicator,
          width: _width,
          icon: Icons.search,
          tooltip: AppLocalizations.of(context)!.search,
          onTap: () async {
            String? searchText = await showDialog(
              barrierDismissible: false,
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
            showSearchIndicator.value = (
              _searchText != null && _searchText != ""
            );
          },
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
          showIndicatorNotifier: showCategoryIndicator,
          width: _width,
          tooltip: AppLocalizations.of(context)!.category,
          icon: Icons.circle,
          onTap: () async {
            Category? selectedCategory = await showCategorySelectionSheet(context);
            _request = _request.copyOf(
              categoryFilter: selectedCategory
            );
            showCategoryIndicator.value = selectedCategory != null;
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
          icon: Icons.restart_alt_rounded,
          onTap: () async {
            final TransactionRequest request = TransactionRequest(
              searchText: null,
              categoryFilter: null,
              timeMode: TimeMode.Individual,
              sortMode: SortMode.DateAsc,
              dateRange: DateTimeRange(
              start: DateTime(DateTime.now().year, DateTime.now().month),
              end: DateTime(DateTime.now().year, DateTime.now().month + 1)
                .subtract(Duration(microseconds: 1)))
            );
            bloc.add(GetTransaction(request));
            showCategoryIndicator.value = false;
            showSearchIndicator.value = false;
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _showRewardedAd() async {
    TransactionState state = BlocProvider.of<TransactionBloc>(context).state;
    if (state is! TransactionLoaded || state.transactionList.isEmpty) {
      showDialog(
        context: context, 
        builder: (context) => ResponseDialog(
          description: AppLocalizations.of(context)!.list_empty, 
          response: Response.Error
        )
      );
      return;
    }

    if (_interstitialAd == null && !adFailedToLoad) {
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
          () => _interstitialAd == null && !adFailedToLoad
        );
      }).timeout(Duration(seconds: 5), onTimeout: () => false);
      Navigator.pop(context);
    }
    if (_interstitialAd != null) {
      _interstitialAd?.show();
    } else {
      _generatePDF();
    }
    _loadRewardedAd();
  }

  Future<void> _loadRewardedAd() async {
    await InterstitialAd.load(
      adUnitId: AdmobHelper.getInterstitialVideoId, 
      request: AdRequest(), 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          adFailedToLoad = false;
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
        onAdFailedToLoad: (error) {
          adFailedToLoad = true;
        },
      )
    );
  }

  void _generatePDF() async {
    TransactionState state = BlocProvider.of<TransactionBloc>(context).state;
    assert(state is TransactionLoaded);
    assert((state as TransactionLoaded).transactionList.isNotEmpty);
    final LoadingProgress loadingProgress = LoadingProgress();
    showDialog(
      context: context, 
      builder: (context) => LoadingDialog(
        loadingProgress: loadingProgress, 
        title: AppLocalizations.of(context)!.generating_invoice,
      ),
      barrierDismissible: false
    );
    Invoice invoice = Invoice(
    transactions: (state as TransactionLoaded).transactionList, 
    color: Theme.of(context).primaryColor,
    );
    await invoice.openInvoice(context);
    loadingProgress.initialize(1);
    loadingProgress.forward();
    loadingProgress.finish();
  }
}

class ViewSelectionBarSection extends StatefulWidget {
  
  final void Function() onDelete;
  final void Function() onSelectAll;
  final void Function() onEdit;
  final void Function() onReset;
  final ValueNotifier<int> selectedTransactionsNotifier;
  
  const ViewSelectionBarSection({
    Key? key,
    required this.onDelete,
    required this.onSelectAll,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20)
            )
          ),
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
              width: _width * 1.15,
              icon: Icons.checklist,
              onTap: widget.onSelectAll,
            ),
            ViewBarIcon(
              width: _width,
              icon: Icons.delete_forever,
              onTap: widget.onDelete,
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
