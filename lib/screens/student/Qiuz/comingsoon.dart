import 'package:flutter/material.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Quiz',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/ComingSoon.jpeg'),
          Utils.sizedBoxHeight(30),
          const Padding(
            padding: EdgeInsets.all(20),
            child: TextWidget(
              txt:
                  'Quiz is currently in development and will be available as a free update in future.',
              align: TextAlign.center,
              clr: Colors.black,
              size: 14,
            ),
          )
        ],
      ),
    );
  }
}
