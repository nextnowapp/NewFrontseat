import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class TxtField extends StatelessWidget {
  TxtField({
    required this.hint,
    Key? key,
    this.pass = false,
    this.controller,
    this.value,
    this.insideHint,
    this.lines = 1,
    this.type,
    this.readonly = false,
    this.validator,
    this.capitalization = TextCapitalization.sentences,
    this.length,
    this.formatter,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.action = TextInputAction.next,
    this.onTap,
    this.focusNode,
    this.icon,
    this.labelIcon,
    this.onChanged,
  }) : super(key: key);
  final String hint;
  final String? value;
  final String? insideHint;
  final bool pass;
  AutovalidateMode? autovalidateMode;
  TextEditingController? controller;
  final int? lines;
  final int? length;
  TextInputAction action;
  TextCapitalization capitalization;
  final TextInputType? type;
  final bool readonly;
  final Function? validator;
  List<TextInputFormatter>? formatter;
  final Widget? icon;
  final Widget? labelIcon;
  FocusNode? focusNode;
  //ontap
  VoidCallback? onTap;
  //onchanged
  Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Visibility(
                child: Row(
                  children: [
                    labelIcon ?? Container(),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                visible: labelIcon != null),
            Text(
              hint,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10.sp,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                ).fontFamily,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.5.h,
        ),
        TextFormField(
          onTap: onTap,
          focusNode: focusNode,
          onChanged: onChanged as void Function(String)?,
          initialValue: value,
          inputFormatters: formatter,
          autovalidateMode: autovalidateMode,
          keyboardType: type,
          textInputAction: action,
          readOnly: readonly,
          controller: controller,
          maxLength: length,
          obscureText: pass,
          maxLines: lines,
          cursorColor: Colors.black,
          showCursor: true,
          cursorWidth: 1.sp,
          cursorHeight: 18.sp,
          textCapitalization: TextCapitalization.sentences,
          enabled: true,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
          decoration: InputDecoration(
            hintText: insideHint,
            suffixIcon: icon,
            fillColor: HexColor('#5374ff'),
            errorStyle: TextStyle(
              fontSize: 8.sp,
              color: HexColor('#de5151'),
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            hintStyle: TextStyle(
              color: HexColor('#8e9aa6'),
              fontSize: 12.sp,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#d5dce0'),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#5374ff'),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
          ),
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else
              return null;
          },
        ),
      ],
    );
  }
}
