import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dollavu/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:dollavu/components/CategorySelectionSheet.dart';
import 'package:dollavu/components/Keyboard.dart';
import 'package:dollavu/components/categoryIcon/CategoryIcon.dart';
import 'package:dollavu/components/categoryIcon/CategoryIconData.dart';
import 'package:dollavu/models/Category.dart';
import 'package:dollavu/services/Database.dart';
import 'package:dollavu/services/HiveDatabase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            height: MediaQuery.of(context).size.width/6,
            width: MediaQuery.of(context).size.width/6,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5,5),
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
              size: MediaQuery.of(context).size.width / 14,
              onTap: onTap,
              iconData: _selectedCategory!.icon!.iconData),
          )
        : RepaintBoundary(
            child: Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width/6,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(5,5),
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
                child: CategoryIcon(
                  size: MediaQuery.of(context).size.width / 17,
                  onTap: onTap,
                  iconData: CategoryIconData(
                    backgroundColorInt: Colors.transparent.value,
                    iconName: "pen",
                    iconColorInt: Theme.of(context).primaryColor.value,
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            child: Text(
              _selectedCategory?.name ?? AppLocalizations.of(context)!.category,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 50,
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
    hideKeyboard(context);
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

