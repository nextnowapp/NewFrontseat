import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {Key? key,
      required this.txt,
      this.size,
      this.weight,
      this.clr,
      this.align,
      this.maxlines,
      this.fam})
      : super(key: key);
  final String txt;
  final double? size;
  final FontWeight? weight;
  final Color? clr;
  final TextAlign? align;
  final String? fam;
  final int? maxlines;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          fontSize: size, fontWeight: weight, color: clr, fontFamily: fam),
      textAlign: align,
      maxLines: maxlines,
    );
  }
}
