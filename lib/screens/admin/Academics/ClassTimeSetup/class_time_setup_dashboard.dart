import 'package:flutter/material.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';

import '../../../../utils/CardItem.dart';
import '../../../../utils/FunctionsData.dart';

// ignore: must_be_immutable
class ClassTimeSetupDashboard extends StatefulWidget {
  var _titles;
  var _images;

  ClassTimeSetupDashboard(this._titles, this._images, {Key? key})
      : super(key: key);

  @override
  _ClassTimeSetupDashboardState createState() =>
      _ClassTimeSetupDashboardState(_titles, _images);
}

class _ClassTimeSetupDashboardState extends State<ClassTimeSetupDashboard> {
  var _titles;
  var _images;
  int? currentSelectedIndex;

  _ClassTimeSetupDashboardState(this._titles, this._images);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Class Time Setup',
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GridView.builder(
            itemCount: _titles.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return CustomWidget(
                index: index,
                isSelected: currentSelectedIndex == index,
                onSelect: () {
                  setState(() {
                    currentSelectedIndex = index;
                  });
                },
                element: AppFunction.getClassTimeSetupDashboardPage(
                    context, _titles[index]),
                headline: _titles[index],
                icon: _images[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
