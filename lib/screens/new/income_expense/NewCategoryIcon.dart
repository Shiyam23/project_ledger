import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';

class NewCategoryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: DottedBorder(
              color: Colors.black,
              strokeWidth: 1,
              dashPattern: [6, 6],
              padding: EdgeInsets.all(1),
              borderType: BorderType.Circle,
              child: CategoryIcon(
                iconData: CategoryIconData(
                  backgroundColor: Colors.white,
                  iconName: "pen",
                  iconColor: Colors.black45,
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Kategorie",
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}
