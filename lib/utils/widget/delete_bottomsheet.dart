import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class DeleteBottomSheet extends StatefulWidget {
  DeleteBottomSheet({required this.onDelete, required this.title, Key? key})
      : super(key: key);
  AsyncCallback onDelete;
  String? title;

  @override
  State<DeleteBottomSheet> createState() => _DeleteBottomSheetState();
}

class _DeleteBottomSheetState extends State<DeleteBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: SizedBox(
          height: 280.sp,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title!,
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                        .fontFamily,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                const Divider(),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  'Are you sure, you want to delete?',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'This data will be permanently lost',
                  style: TextStyle(
                    color: HexColor('#de5151'),
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                    width: 80.w,
                    height: 6.h,
                    child: TextButton(
                      child: Text(
                        'Go back',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily:
                              GoogleFonts.inter(fontWeight: FontWeight.w400)
                                  .fontFamily,
                          fontSize: 12.sp,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.grey.shade200)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                    width: 80.w,
                    height: 6.h,
                    child: TextButton(
                        child: Center(
                          child: Text(
                            'I understand, continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily:
                                  GoogleFonts.inter(fontWeight: FontWeight.bold)
                                      .fontFamily,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: HexColor('#de5151'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: widget.onDelete))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
