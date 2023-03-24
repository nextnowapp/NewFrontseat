import 'package:flutter/material.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

class DetailFields extends StatelessWidget {
  DetailFields({Key? key, required this.title, required this.value})
      : super(key: key);
  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          TextWidget(
            txt: title,
            weight: FontWeight.w500,
            size: 16,
          ),
          Expanded(
            child: TextWidget(
              txt: ' ' + value,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
