import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/IconSelectionSheet.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/services/Database.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';

import '../ResponseDialog.dart';
import '../TextInputDialog.dart';

class CategoryPage extends StatefulWidget {

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Category> _categoryList = [];
  final TextEditingController _controller = TextEditingController();
  final Database _database = HiveDatabase();
  late Future<List<Category>> allCategories;

  @override
  void initState() {
    super.initState();
    allCategories = _database.getAllCategories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: FutureBuilder(
        future: allCategories,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            _categoryList.clear();
            _categoryList.addAll(snapshot.data as List<Category>);
            return AnimatedList(
              initialItemCount: _categoryList.length + 1,
              key: _listKey,
              itemBuilder: (context, index, animation) => 
                index < _categoryList.length ? 
                _listbuilder(context, _categoryList[index], animation):
                Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: const Text("Add new account"),
                    onTap: () => addCategory(context),
                    leading: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 1,
                      dashPattern: [6, 6],
                      padding: const EdgeInsets.all(1),
                      borderType: BorderType.Circle,
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      )
                    )
                  ),
                )
            );
          }
          else {
            return Center(child: const CircularProgressIndicator());
          }
        }
      ),
    );
  }

  Widget _listbuilder(BuildContext context, Category category, Animation<double> animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          child: StatefulBuilder(
            builder: (context, listSetState) => ListTile(
              key: ObjectKey(category),
              contentPadding: const EdgeInsets.all(10),
              title: Text(category.name ?? "..."),
              onLongPress: () {
                showCategoryMenu(context, category, listSetState);
              },
              leading: category.icon,
            ),
          ),
        ),
      );
    }

  void showCategoryMenu(BuildContext context, Category category, StateSetter listSetState) {
    showModalBottomSheet(context: context, builder: (sheetContext) {
      return Wrap(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Edit name"),
            leading: const Icon(Icons.edit),
            onTap: () => saveNewName(context, category, listSetState)
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Change Icon"),
            leading: const Icon(Icons.circle),
            onTap: () => saveNewIcon(context, category, listSetState)
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Delete account"),
            leading: const Icon(Icons.delete),
            onTap: () => deleteCategory(context, category)
          ),
        ]
      );
    });    
  }

  void addCategory(BuildContext context) async {
    _controller.text = "My Category";
    String? iconName;
    int? colorInt;
    String? name = await showDialog<String>(
      context: context, 
      builder: (context) => TextInputDialog(
        title: const Text("Enter a name for the new category"),
        controller: _controller,
        prefixIcon: const Icon(Icons.edit),
        )
    );
    if (_categoryList.contains((category) => category.name == name)) {
      showDialog(
        context: context, 
        builder: (_) => ResponseDialog(
          description: "A category with an identical name already exists.", 
          response: Response.Error
        )
      );
      return;       
    }
    if (name != null) {
      iconName = await showIconSheet(context, false);
      if (iconName != null) {
        colorInt = await showIconSheet(context, true);
        if (colorInt != null) {
          Category newCategory = Category(
            name: name,
            icon: CategoryIcon(
              iconData: CategoryIconData(
                iconName: iconName,
                backgroundColorInt: colorInt
              )
            )   
          );
          _database.addCategory(newCategory);
          allCategories = _database.getAllCategories();
          _categoryList.add(newCategory);
          Timer(
            const Duration(milliseconds: 300),
            () => _listKey.currentState!.insertItem(_categoryList.length-1)
          );
        }
      }
    }
  }

  void saveNewName(BuildContext context, Category oldCategory, StateSetter listSetState) async {
    _controller.text = oldCategory.name!;
    _controller.selection = TextSelection(
      baseOffset: 0, 
      extentOffset: oldCategory.name!.length
    );
    Navigator.of(context).pop();
    String? newName = await getSelectedName(context);
    if (_categoryList
      .map((Category category) => category.name!.toLowerCase())
      .contains(newName?.toLowerCase())) 
    {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Category with this name already exists"),
          content: Text("You already have a category with the name \"$newName\"." + 
            "You can not have two categories with the same name."),
        )
      );
      return;
    }
    else if (
      newName != null &&
      newName != oldCategory.name && 
      newName.isNotEmpty
    ){
      Category newCategory = oldCategory.copyWith(
        name: newName
      );
      bool noError = await _database.changeCategory(oldCategory, newCategory);
      if (noError) {
        allCategories = _database.getAllCategories();
        setState(() => {});
      }
    } 
  }

  Future<String?> getSelectedName(BuildContext context) async {
    String? name = await showDialog<String>(
      context: context, 
      builder: (context) => TextInputDialog(
        title: const Text("Enter a name for a category"),
        controller: _controller,
        prefixIcon: const Icon(Icons.edit),
        )
    );
    return Future.value(name);
  }

  void saveNewIcon(BuildContext context, Category oldCateogry, StateSetter listSetState) async {
    Navigator.of(context).pop();
    int? colorInt;
    String? iconName = await showIconSheet(context, false);
    if (iconName != null) {
      colorInt = await showIconSheet(context, true);
      if (colorInt != null) {
        Category newCategory = oldCateogry.copyWith(
          icon: CategoryIcon(
              iconData: CategoryIconData(
                iconName: iconName,
                backgroundColorInt: colorInt
              ))
        );
        bool noError = await _database.changeCategory(oldCateogry, newCategory);
        if (noError) {
          allCategories = _database.getAllCategories();
          setState(() {});
        }
      }
    }
  }

  void deleteCategory(BuildContext context, Category category) async {
    Navigator.of(context).pop();
    bool? sureToDelete = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Delete category?"),
        content: const Text("Are you sure that you want to delete this category? " + 
        "All transactions associated with this category will be deleted permanently!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete")
          ),
        ],
      ));
    if (sureToDelete ?? false) {
      int index = _categoryList.indexOf(category);
      _listKey.currentState!.removeItem(
        index, 
        (context, animation) => _listbuilder(context, category, animation), 
      );
      _categoryList.removeAt(index);
      _database.deleteCategory(category);
      allCategories = _database.getAllCategories();
    }
  } 

  @override
  void dispose() { 
    _controller.dispose();    
    super.dispose();
  }
}