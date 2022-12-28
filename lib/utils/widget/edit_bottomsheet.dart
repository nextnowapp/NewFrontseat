import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditBottomSheet extends StatefulWidget {
  EditBottomSheet({required this.onEdit, Key? key}) : super(key: key);
  AsyncCallback onEdit;
  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: SizedBox(
          height: ScreenUtil().setHeight(280),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600)
                        .fontFamily,
                    fontSize: 17.sp,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Are you sure, you want to update?',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "This action can't be undone",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: GoogleFonts.inter(
                            color: Colors.red,)
                        .fontFamily,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 27.h,
                ),
                SizedBox(
                    width: 800.w,
                    height: 40.h,
                    child: TextButton(
                      child: Text(
                        'Go back',
                      style: TextStyle(
                              color: Colors.black,
                              fontFamily:
                                  GoogleFonts.inter(fontWeight: FontWeight.bold)
                                      .fontFamily,
                              fontSize: 15.sp,
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
                  height: 10.h,
                ),
                SizedBox(
                    width: 800.w,
                    height: 40.h,
                    child: TextButton(
                      child: Center(
                        child: Text(
                          'I understand, continue',
                         style: TextStyle(
                              color: Colors.white,
                              fontFamily:
                                  GoogleFonts.inter(fontWeight: FontWeight.bold)
                                      .fontFamily,
                              fontSize: 15.sp,
                            ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF4E88FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: widget.onEdit,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
