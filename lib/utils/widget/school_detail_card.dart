import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class SchoolDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final String image;
  final AsyncCallback? ontap;

  const SchoolDetailCard({
    Key? key,
    required this.title,
    required this.value,
    required this.image,
    this.ontap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 10,
        right: 10,
      ),
      margin: const EdgeInsets.only(
        top: 6,
        bottom: 6,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            child: SvgPicture.asset(
              image,
            ),
          ),
          //divider
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            width: 1,
            color: Colors.grey[400],
          ),
          //text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: HexColor('#8e9aa6'),
                    fontFamily: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                InkWell(
                  onTap: ontap,
                  child: Text(
                    value,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ).fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
