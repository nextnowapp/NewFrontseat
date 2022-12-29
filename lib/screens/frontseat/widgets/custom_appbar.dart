import 'package:flutter/material.dart';

import '../../../utils/widget/textwidget.dart';

class CustomAppbar extends StatelessWidget {
  CustomAppbar({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        width: double.infinity,
        color: Colors.red,
        child: Center(
            child: TextWidget(
          txt: title,
          clr: Colors.white,
          size: 20,
          weight: FontWeight.w500,
        )),
      ),
    );
  }
}
