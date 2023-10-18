import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import 'constants.dart';

typedef void CallbackButtonTap({String buttonText});

class KeyboardButtons extends StatelessWidget {
  KeyboardButtons({this.buttons, @required this.onTap});

  final String? buttons;
  final CallbackButtonTap? onTap;

  bool _colorTextButtons() {
    return (buttons == DEL_SIGN ||
        buttons == CLEAR_ALL_SIGN ||
        buttons == MODULAR_SIGN);
  }

  bool _basicOperators() {
    return (buttons == PLUS_SIGN ||
        buttons == MINUS_SIGN ||
        buttons == MULTIPLICATION_SIGN ||
        buttons == DIVISION_SIGN);
  }

  bool _fontSize() {
    return (buttons == LN_SIGN ||
        buttons == LG_SIGN ||
        buttons == SIN_SIGN ||
        buttons == COS_SIGN ||
        buttons == TAN_SIGN ||
        buttons == RAD_SIGN ||
        buttons == DEG_SIGN ||
        buttons == ARCSIN_SIGN ||
        buttons == ARCCOS_SIGN ||
        buttons == ARCTAN_SIGN ||
        buttons == LN2_SIGN ||
        buttons == LEFT_QUOTE_SIGN ||
        buttons == RIGHT_QUOTE_SIGN);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap!(buttonText: buttons!),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            width: 6.w,
            height: 7.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (buttons == EQUAL_SIGN)
                  ? HexColor('#3bb18e')
                  : HexColor('#f2f2f2'),
            ),
            child: Text(
              buttons!,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: (_colorTextButtons())
                      ? Colors.blueAccent
                      : (buttons == EQUAL_SIGN)
                          ? Theme.of(context).primaryColor
                          : (_basicOperators())
                              ? HexColor('#e74239')
                              : const Color(0xFF444444),
                  fontSize: _fontSize()
                      ? 18
                      : (_basicOperators() || _colorTextButtons())
                          ? 24
                          : 20.0),
            ),
          ),
        ),
      ),
    );
  }
}
