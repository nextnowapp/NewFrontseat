import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoleSelectCard extends StatelessWidget {
  final String message;
  final String btnText;
  final bool reverse;
  final Function onPressed;
  final LinearGradient? bgGradient;
  final String image;

  const RoleSelectCard(
      {Key? key,
      required this.message,
      required this.btnText,
      this.reverse = false,
      required this.onPressed,
      this.bgGradient,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: bgGradient,
        ),
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
          children: [
            SvgPicture.asset(
              image,
              height: 100,
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white),
                      splashFactory: InkRipple.splashFactory,
                      enableFeedback: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      btnText,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  onPressed: onPressed as void Function()?,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
