import 'package:flutter/material.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

class NextButton extends StatelessWidget {
  const NextButton({this.color = const Color(0xFF3ab28d), Key? key})
      : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 10),
          TextWidget(
              txt: 'Next',
              clr: Colors.white,
              size: 16,
              weight: FontWeight.w500),
          Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 26,
          ),
        ],
      ),
    );
  }
}
