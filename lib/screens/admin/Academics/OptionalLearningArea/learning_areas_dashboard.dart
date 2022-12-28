import 'package:flutter/material.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';

import '../../../../utils/CardItem.dart';

// ignore: must_be_immutable
class LearningAreasDashboard extends StatefulWidget {
  var _titles;
  var _images;

  LearningAreasDashboard(this._titles, this._images, {Key? key})
      : super(key: key);

  @override
  _LearningAreasDashboardState createState() =>
      _LearningAreasDashboardState(_titles, _images);
}

class _LearningAreasDashboardState extends State<LearningAreasDashboard> {
  var _titles;
  var _images;
  int? currentSelectedIndex;

  _LearningAreasDashboardState(this._titles, this._images);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Learning Areas',
      ),
      backgroundColor: Colors.white,
      body: Container(
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
              element: AppFunction.getLearningAreasDashboardPage(
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
