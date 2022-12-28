import 'package:flutter/material.dart';

class TxtBox extends StatelessWidget {
  TxtBox(
      {required this.hint,
      Key? key,
      this.pass = false,
      this.controller,
      this.lines = 1,
      this.type,
      this.readonly = false,
      this.validator,
      this.capitalization = TextCapitalization.none,
      this.length,
      this.rule,
      this.icon})
      : super(key: key);
  final String hint;
  final bool pass;
  TextEditingController? controller;
  final int? lines;
  TextCapitalization capitalization;
  final TextInputType? type;
  final bool readonly;
  final Function? validator;
  final Icon? icon;
  final int? length;
  int? rule;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          style: const TextStyle(color: Colors.black54, fontSize: 16),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: type,
          textInputAction: TextInputAction.next,
          readOnly: readonly,
          controller: controller,
          maxLength: length,
          obscureText: pass,
          maxLines: lines,
          cursorHeight: 1,
          textCapitalization: capitalization,
          decoration: InputDecoration(
              floatingLabelStyle:
                  const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                labelStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
              contentPadding: const EdgeInsets.only(left: 5, right: 5),
              labelText: hint,
              alignLabelWithHint: true,
              suffixIcon: Visibility(
               visible: rule == 1||rule ==5,
                child: const Icon(
                  Icons.mode_edit_rounded,
                  size: 14,
                ),
              )),
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else
              return null;
          },
        ));
  }
}
