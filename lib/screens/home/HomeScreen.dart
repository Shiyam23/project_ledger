import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/blocs/bloc/accountChanged/AccountChangedCubit.dart';
import 'package:project_ez_finance/components/button/Button.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import '../../models/CategoryChartInfo.dart';

class HomeScreen extends StatefulWidget {

  final Future<void> Function(int) setPage;

  HomeScreen({
    Key? key,
    required this.setPage
  }) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: screenWidth,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Invoice",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  Text(_formatCurrentMonth(),
                    style: TextStyle(
                      fontSize: 20,
                      overflow: TextOverflow.fade,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  SizedBox(height: 10),
                  RoundGradientButton(
                    onPressed: () => {}, 
                    text: "CREATE",
                    widthRatio: 0.3,
                  )
                ],
              ),
              Icon(
                FontAwesomeIcons.fileInvoice,
                color: Theme.of(context).primaryColor,
                size: 100,
              )
            ],
          ),
          Divider(
            color: Theme.of(context).primaryColor,
            height: 50,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        _formatCurrentMonth(),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                    Text("Top 5 Categories",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ],
                ),
              ),
              RoundGradientButton(
                onPressed: () {
                  widget.setPage(0);
                }, 
                text: "SEE MORE",
                widthRatio: 0.3
              )
            ],
          ),
          BlocBuilder<AccountChangedCubit, int>(
            bloc: BlocProvider.of<AccountChangedCubit>(context),
            buildWhen: (oldHash, newHash) => oldHash != newHash,
            builder: (context,_) {
              return FutureBuilder(
              future: CategoryChartInfo.getTopFiveCategories(),
              builder: (context, snapshot) {
                print(snapshot.hasData);
                if (!snapshot.hasData) {
                  return Expanded(child: Center(child: CircularProgressIndicator()));
                }
                else {
                  List<CategoryChartInfo> chartList = 
                    snapshot.data as List<CategoryChartInfo>;
                  if (chartList.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text("No transactions yet ..."),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: 
                        diagramRow((snapshot.data as List<CategoryChartInfo>), context)
                    ),
                  );
                }
              } 
            );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> diagramRow(List<CategoryChartInfo> list, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxAmount = list[0].amount;
    return list.map((category) {
      return Padding(
       padding: const EdgeInsets.only(top: 20.0),
       child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width / 8,
            width: MediaQuery.of(context).size.width / 8,
            child: CategoryIcon(
              iconData: category.categoryIconData
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: Text(
                  category.categoryName,
                  style: TextStyle(
                    inherit: true,
                    fontSize:18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Color.fromRGBO(56, 100, 132, 1)
                        ]
                      )
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width 
                        *0.65 * category.amount / maxAmount, 
                      height: screenWidth *0.65 * 0.1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: (category.amount/maxAmount < 0.5) ? 
                            null : 
                            Text(
                            category.displayedAmount,
                            style: TextStyle(
                              overflow: TextOverflow.fade,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  (category.amount/maxAmount > 0.5) ? 
                    SizedBox() : 
                    Text(
                      category.displayedAmount,
                      style: TextStyle(
                        overflow: TextOverflow.fade,
                        color: Colors.black
                      )
                    ),
                ],
              ),
            ],
          )
        ],
    ),
     );
    }).toList();
  }

  String _formatCurrentMonth() {
    return DateFormat("MMMM yyyy").format(DateTime.now());
  }
}
