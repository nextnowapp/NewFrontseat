import 'package:flutter/material.dart';

import '../../../../utils/widget/textwidget.dart';

class DetailCard extends StatelessWidget {
  const DetailCard(
      {Key? key,
      required this.scale,
      required this.title,
      required this.buttonColor,
      required this.buttonIcon,
      required this.buttonText,
      required this.title2,
      required this.buttonWidgetColor,
      required this.asset})
      : super(key: key);
  final String asset;
  final String title;
  final String title2;
  final double scale;
  final Color buttonColor;
  final IconData buttonIcon;
  final String buttonText;
  final Color buttonWidgetColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  asset,
                  scale: scale,
                )),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextWidget(
                txt: title,
                clr: Colors.black,
                size: 18,
                weight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextWidget(
                txt: title2,
                clr: Colors.black,
                size: 18,
                weight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: buttonColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      buttonIcon,
                      color: buttonWidgetColor,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Container(
                        child: TextWidget(
                          overflow: TextOverflow.clip,
                          txt: buttonText.toUpperCase(),
                          clr: buttonWidgetColor,
                          size: 13,
                          weight: FontWeight.bold,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
