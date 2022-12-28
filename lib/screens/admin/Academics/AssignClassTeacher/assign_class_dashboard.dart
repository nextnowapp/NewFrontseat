import 'package:flutter/material.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';

import '../../../../utils/CardItem.dart';
import '../../../../utils/FunctionsData.dart';

// ignore: must_be_immutable
class AssignClassTeacherDashboard extends StatefulWidget {
  var _titles;
  var _images;

  AssignClassTeacherDashboard(this._titles, this._images, {Key? key})
      : super(key: key);

  @override
  _AssignClassTeacherDashboardState createState() =>
      _AssignClassTeacherDashboardState(_titles, _images);
}

class _AssignClassTeacherDashboardState
    extends State<AssignClassTeacherDashboard> {
  var _titles;
  var _images;
  int? currentSelectedIndex;

  _AssignClassTeacherDashboardState(this._titles, this._images);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Assign Class Teacher',
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: _titles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;
                });
              },
              element: AppFunction.getAssignClassTeacherDashboardPage(
                  context, _titles[index]),
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}
