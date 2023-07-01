import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dollavu/blocs/bloc/bloc.dart';
import 'package:dollavu/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:dollavu/components/LayoutController.dart';
import 'package:dollavu/components/MainBottomNavigationBar.dart';
import 'package:dollavu/screens/home/HomeAppBar.dart';
import 'package:dollavu/screens/home/HomeScreen.dart';
import 'package:dollavu/screens/new/NewTransactionScreen.dart';
import 'package:dollavu/screens/new/NewTabBar.dart';
import 'package:dollavu/screens/new/NewTemplateScreen.dart';
import 'package:dollavu/screens/view/ViewStandingOrderScreen.dart';
import 'package:dollavu/screens/view/ViewTransactionScreen.dart';
import 'package:dollavu/screens/view/ViewTabBar.dart';
import 'package:dollavu/components/Keyboard.dart';

class Layout extends StatefulWidget {

  final ChangeNotifier homescreenChanged = ChangeNotifier();

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with TickerProviderStateMixin {
  //
  LayoutController? lController;
  TransactionBloc transactionBloc = TransactionBloc(TransactionLoading());
  
  bool keyboardOpen = false;
  late KeyBoard keyboard;

  @override
  void initState() {
    keyboard = KeyBoard();
    super.initState();
    transactionBloc.add(UpdateStandingOrderTransactions());
    lController = LayoutController(
      bottomSelectedIndex: 1,
      currentPage: 2,
      newTabController:
          TabController(length: 2, initialIndex: 0, vsync: this),
      overViewTabController:
          TabController(length: 2, initialIndex: 1, vsync: this),
      pageController: PageController(
        initialPage: 2, 
        keepPage: true,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getTopBar(lController!.currentPage!) as PreferredSizeWidget? ,
      body: buildPageView(),
      bottomNavigationBar: MainBottomNaviationBar(
        layoutController: lController,
        setPage: setPage,
      )
    );
  }

  Widget buildPageView() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => transactionBloc),
        BlocProvider(create: (_) => TransactionDetailsCubit()),
      ],
      child: PageView(
        controller: lController!.pageController,
        onPageChanged: pageChanged,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          ViewStandingOrderScreen(),
          ViewTransactionScreen(),
          HomeScreen(setPage: setPage),
          NewTransactionScreen(),
          NewTemplateScreen(setPage)
        ],
      ),
    );
  }

  void pageChanged(int index) {
    if (index != 3) {
      hideKeyboard(context);
    }
    lController!.currentPage = index;
    if (lController!.pageController.page! + index < 2) {
      lController!.overViewTabController
          .animateTo(index, duration: Duration(milliseconds: 500));
      return;
    }
    if (lController!.pageController.page! + index > 6) {
      lController!.newTabController
          .animateTo(index - 3, duration: Duration(milliseconds: 500));
      return;
    }
    setState(() {
      lController!.bottomSelectedIndex = index - 1;
    });
  }

  Future<void> setPage(index) async {
    if ((lController!.currentPage! - (index + 1)).abs() > 1)
      lController!.pageController.jumpToPage(index + 1);
    else
      await lController!.pageController.animateToPage(index + 1,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    lController!.currentPage = index + 1;
  }

  Widget? getTopBar(int index) {
    if (index < 2)
      return ViewTabBar(
        layoutController: lController,
        setPage: setPage,
      );
    if (index == 2) return const HomeAppBar();
    if (index > 2)
      return NewTabBar(
        layoutController: lController,
        setPage: setPage,
      );
    return null;
  }

  @override
  void dispose() {
    transactionBloc.close();
    super.dispose();
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
    mass: 0.5,
    stiffness: 1000,
    ratio: 1.1,
  );
}

