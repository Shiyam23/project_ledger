import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/services/Database.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';

class NewCategoryIcon extends StatefulWidget {
  static const Database _database = HiveDatabase();
  final void Function(Category? category) onSelection;

  NewCategoryIcon(this.onSelection);

  @override
  State<StatefulWidget> createState() {
    return NewCategoryIconState(_database);
  }
}

class NewCategoryIconState extends State<NewCategoryIcon> {
  static const Database _database = HiveDatabase();
  Category? _selectedCategory;

  NewCategoryIconState(_database);

@override
Widget build(BuildContext context) {
  return Column(
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
            child: CategoryIcon(
              onTap: onTap,
              iconData: CategoryIconData(
                backgroundColorInt: Colors.white.value,
                iconName: "pen",
                iconColorInt: Colors.black45.value,
              ),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          alignment: Alignment.center,
          width: 50,
          child: Text(
            _selectedCategory?.name ?? "Kategorie",
            style: const TextStyle(fontSize: 10),
          ),
        ),
      )
    ],
  );
}

void onTap() async {
  
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
              future: _database.getAllCategories(),
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
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                        children: (snapshot.data as List<Category>).map<Widget>(
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
                                        style: const TextStyle(
                                        fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ).toList()
                      ),
                    ),
                  );
                } else return CircularProgressIndicator();
            }),
          ),
        );
      });
    widget.onSelection(selectedCategory);
    setState(() => {
      _selectedCategory = selectedCategory
    });

  }
}

