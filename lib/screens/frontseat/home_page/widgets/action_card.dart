import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../utils/widget/textwidget.dart';


class ActionCards extends StatelessWidget {
  final String title;
  final Color bgColor;
  final String asset;
  final Color titleBg;
  final AsyncCallback ontap;

  const ActionCards(
      {Key? key,
      required this.title,
      required this.ontap,
      required this.titleBg,
      required this.asset,
      required this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: bgColor,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          elevation: 1,
          shadowColor: Colors.grey[50],
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  asset,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextWidget(
                    txt: title,
                    // weight: FontWeight.w500,
                    align: TextAlign.center,
                    size: 16,
                    clr: titleBg,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}