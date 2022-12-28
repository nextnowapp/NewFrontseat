import 'package:flutter/material.dart';
import 'package:nextschool/utils/CardItem.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';

class QuizHome extends StatefulWidget {
  var _titles;
  var _images;
  var id;

  QuizHome(this._titles, this._images, {this.id, Key? key});

  @override
  _QuizHomeState createState() => _QuizHomeState(_titles, _images);
}

class _QuizHomeState extends State<QuizHome> {
  var _titles;
  var _images;
  bool? isTapped;
  int? currentSelectedIndex;

  _QuizHomeState(this._images, this._titles);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Quiz'),
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
              element: AppFunction.getQuizDashboardPage(context, _titles[index],
                  id: widget.id),
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}
