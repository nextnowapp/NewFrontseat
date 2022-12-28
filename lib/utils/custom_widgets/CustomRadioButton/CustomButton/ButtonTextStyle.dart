// Flutter imports:
import 'package:flutter/material.dart';

class ButtonTextStyle {
  ///Selected color of Text
  final Color selectedColor;

  ///Unselected color of Text
  final Color unSelectedColor;
  final TextStyle textStyle;

  const ButtonTextStyle(
      {this.selectedColor = Colors.black,
      this.unSelectedColor = Colors.grey,
      this.textStyle = const TextStyle(fontWeight: FontWeight.w400)});
}
