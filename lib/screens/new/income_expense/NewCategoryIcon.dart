import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
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
    cubit.emit(cubit.state.copyWith(category: null));
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
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: _selectedCategory != null ?
            CategoryIcon(
              onTap: onTap,
              iconData: _selectedCategory!.icon!.iconData)
          : DottedBorder(
              color: Colors.black,
              strokeWidth: 1,
              dashPattern: [6, 6],
              padding: const EdgeInsets.all(1),
              borderType: BorderType.Circle,
              child: SlideTransition(
                position: _offsetAnimation,
                child: CategoryIcon(
                  onTap: onTap,
                  iconData: CategoryIconData(
                    backgroundColorInt: Colors.transparent.value,
                    iconName: "pen",
                    iconColorInt: Colors.black45.value,
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            alignment: Alignment.center,
            width: 50,
            child: Text(
              _selectedCategory?.name ?? "Category",
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    )
  );
}

  void onTap() async {
    KeyboardWidget.of(context)!.triggerKeyboard(false);
    Category? selectedCategory = await showModalBottomSheet<Category>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      )
      enableDrag: true,
      isDismissible: true,
      context: context, 
      builder: (context) {
        return Scrollbar(
          radius: Radius.circular(20),
          thickness: 20,
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: widget._database.getAllCategories(),
              builder: (context, snapshot) { 
                if (snapshot.hasData) {
                  if ((snapshot.data as List<Category>).isEmpty) {
                    return Center(
                      child: Text(
                        "No Categories available. " + 
                        "Please create a category to add a new transaction!",
                        ),
                    )
                  }
                  return Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.spaceEvenly,
                        alignment: WrapAlignment.start,
                        spacing: 20,
                        runSpacing: 20,
                        children: getCategoryWidgetList(snapshot.data as List<Category>)
                      ),
                    ),
                  );
                } else return CircularProgressIndicator();
            }),
          ),
        );
      });
    widget.onSelect(selectedCategory);
  }

  List<Widget> getCategoryWidgetList(List<Category> list) {
    List<Widget> result = list.map<Widget>(
      (category) => Column(
        children: [
          CategoryIcon(
            iconData: category.icon!.iconData,
            onTap: () => Navigator.pop<Category>(context, category)
          ,),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              alignment: Alignment.center,
              width: 50,
              child: Text(
                category.name!, 
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      )
    ).toList();
    result.add(Divider(
      thickness: 2,
      height: 2,
    ));
    return result;
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

