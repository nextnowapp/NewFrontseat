import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class AddnDeleteButton extends StatelessWidget {
  AddnDeleteButton({
    Key? key,
    required this.title,
    required this.borderColor,
    required this.textColor,
    this.icon,
    this.bgColor,
  }) : super(key: key);
  String title;
  IconData? icon;
  String borderColor;
  String textColor;
  String? bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 50,
      decoration: BoxDecoration(
          color: HexColor(bgColor ?? '#ffffff'),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: HexColor(borderColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 9.0),
                  child: Icon(
                    icon,
                    size: 14.sp,
                    color: HexColor(textColor),
                  ),
                )
              : Container(),
          Text(
            title,
            style: TextStyle(
              color: HexColor(textColor),
              fontFamily:
                  GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
              fontSize: 12.sp,
            ),
          )
        ],
      ),
    );
  }
}
