 import 'package:flutter/material.dart';
import 'package:dollavu/components/categoryIcon/CategoryIcon.dart';
import 'package:dollavu/models/Category.dart';
import 'package:dollavu/services/HiveDatabase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
 
 Future<Category?> showCategorySelectionSheet(BuildContext context) async {
    Future<List<Category>> allCategories = HiveDatabase().getAllCategories();
    Category? selectedCategory = await showModalBottomSheet<Category>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      enableDrag: true,
      isDismissible: true,
      context: context, 
      builder: (context) {
        return Scrollbar(
          radius: Radius.circular(20),
          thickness: 20,
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: allCategories,
              builder: (context, snapshot) { 
                if (snapshot.hasData) {
                  if ((snapshot.data as List<Category>).isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_category_error
                      ),
                    );
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
                        children: getCategoryWidgetList(
                          snapshot.data as List<Category>, 
                          context
                        )
                      ),
                    ),
                  );
                } else return CircularProgressIndicator();
            }),
          ),
        );
      });
      return selectedCategory;
  }

  List<Widget> getCategoryWidgetList(List<Category> list, BuildContext context) {
    List<Widget> result = list.map<Widget>(
      (category) => Column(
        children: [
          CategoryIcon(
            size: MediaQuery.of(context).size.width / 15,
            iconData: category.icon!.iconData,
            onTap: () => Navigator.pop<Category>(context, category)
          ,),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SizedBox(
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