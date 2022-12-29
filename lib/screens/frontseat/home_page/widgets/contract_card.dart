import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../utils/widget/textwidget.dart';


class ContractCards extends StatelessWidget {
  const ContractCards(
      {required this.bgColor,
      required this.title,
      required this.ontap,
      Key? key})
      : super(key: key);
  final String title;
  final Color bgColor;
  final AsyncCallback ontap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: ontap,
        child: Card(
          color: bgColor,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          elevation: 1,
          shadowColor: Colors.grey[50],
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextWidget(txt: title, weight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}