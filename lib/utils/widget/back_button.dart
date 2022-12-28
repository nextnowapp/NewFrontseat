import 'package:flutter/material.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

class BackBtn extends StatelessWidget {
  const BackBtn(
      {this.textColor = const Color(0xFF3ab28d),
      this.color = const Color(0xFF3ab28d),
      Key? key})
      : super(key: key);
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 90,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.navigate_before,
            color: textColor,
            size: 26,
          ),
          TextWidget(
            txt: 'Back',
            clr: textColor,
            size: 16,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
