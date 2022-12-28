import 'package:flutter/material.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

class StepsIndicator extends StatelessWidget {
  const StepsIndicator(
      {Key? key,
      this.clr1 = Colors.black12,
      this.clr2 = Colors.black12,
      this.clr3 = Colors.black12,
      this.d1,
      this.d2})
      : super(key: key);

  final Color clr1;
  final Color clr2;
  final Color clr3;
  final Color? d1;
  final Color? d2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(children: <Widget>[
        CircleAvatar(
          radius: 10,
          child: const TextWidget(
            txt: '1',
            size: 12,
            clr: Colors.white,
          ),
          backgroundColor: clr1,
        ),
        Expanded(
            child: Divider(
          color: d1,
          thickness: 2,
        )),
        CircleAvatar(
          radius: 10,
          child: const TextWidget(
            txt: '2',
            size: 10,
            clr: Colors.white,
          ),
          backgroundColor: clr2,
        ),
        Expanded(
            child: Divider(
          color: d2,
          thickness: 2,
        )),
        CircleAvatar(
          radius: 10,
          child: const TextWidget(
            txt: '3',
            size: 12,
            clr: Colors.white,
          ),
          backgroundColor: clr3,
        ),
      ]),
    );
  }
}
