import 'package:flutter/material.dart';
import 'categoryIcon/CategoryIcon.dart';
import 'categoryIcon/CategoryIconData.dart';

  
  Future<dynamic> showIconSheet(BuildContext context, bool showOnlyColor) async {
    dynamic result = await showModalBottomSheet<dynamic>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(10)),
      ),
      enableDrag: true,
      isDismissible: true,
      context: context, 
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                showOnlyColor ? "Select background color" : "Select icon",
                style: const TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            Scrollbar(
              radius: const Radius.circular(20),
              thickness: 20,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                      children: _getSheetElementList(context, showOnlyColor)
                    ),
                  ),
                )
              ),
            ),
          ],
        );
      });
      return Future.value(result);
  }

  List<Widget> _getSheetElementList(context, bool showOnlyColor) {
    return showOnlyColor ?
    CategoryIconData.colorList.map((colorInt) => CategoryIcon(
        onTap: () => Navigator.of(context).pop(colorInt),
        iconData: CategoryIconData(
          backgroundColorInt: colorInt
    ))).toList() :
    CategoryIconData.iconList.keys.map((name) => CategoryIcon(
        onTap: () => Navigator.of(context).pop(name),
        iconData: CategoryIconData(
          iconName: name,
    ))).toList(); 
  
}