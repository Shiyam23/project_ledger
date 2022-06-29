import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:project_ez_finance/components/CategorySelectionSheet.dart';
import 'package:project_ez_finance/components/Keyboard.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/services/Database.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';

class NewCategoryIcon extends StatefulWidget {
  final Database _database = HiveDatabase();
  final void Function(Category? category) onSelect;

  NewCategoryIcon({
    required this.onSelect,
    key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NewCategoryIconState(_database);
  }
}

class NewCategoryIconState extends State<NewCategoryIcon> with SingleTickerProviderStateMixin{
  Category? _selectedCategory;

  NewCategoryIconState(_database);
  late AnimationController _animationController = AnimationController(
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(-0.02,0.02),
    end: Offset(0.03,-0.03),
  ).animate(CurvedAnimation(
    parent: _animationController, 
    curve: Curves.easeInOut)
  );

  @override
  void initState() { 
    _animationController.repeat(
      reverse: true,
      period: Duration(milliseconds: 500)
    );
    TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);
    cubit.projectDetails(cubit.state.copyWith(category: null));
    super.initState();
  }

@override
Widget build(BuildContext context) {
  return BlocConsumer<TransactionDetailsCubit, TransactionDetails>(
    listener: (context, state) {
      if (state.category != this._selectedCategory) {
        updateCategory(state.category);
      }
    },
    builder: (context, state) => Column(
      children: <Widget>[
        _selectedCategory != null ?
          Container(
            width: MediaQuery.of(context).size.height/15,
            height: MediaQuery.of(context).size.height/15,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(5,5),
                  blurRadius: 5,
                  color: Colors.black26
                )
              ],
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(50)
            ),
            child: CategoryIcon(
              onTap: onTap,
              iconData: _selectedCategory!.icon!.iconData),
          )
        : Container(
            height: MediaQuery.of(context).size.height/15,
            width: MediaQuery.of(context).size.height/15,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(5,5),
                  blurRadius: 5,
                  color: Colors.black26
                )
              ],
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).canvasColor,
              border: Border.all(
                color: Colors.black26
              )
            ),
            padding: const EdgeInsets.all(1),
            child: SlideTransition(
              position: _offsetAnimation,
              child: Transform.scale(
                scale: 1,
                child: CategoryIcon(
                  size: MediaQuery.of(context).size.width*0.045,
                  onTap: onTap,
                  iconData: CategoryIconData(
                    backgroundColorInt: Colors.transparent.value,
                    iconName: "pen",
                    iconColorInt: Theme.of(context).primaryColor.value,
                  ),
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              _selectedCategory?.name ?? "Category",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    )
  );
}

  void onTap() async {
    Category? selectedCategory = await showCategorySelectionSheet(context);
    widget.onSelect(selectedCategory);
  }

  

  void updateCategory(Category? category) {
    setState(() => _selectedCategory = category);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

