import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadBottomSheet extends StatefulWidget {
  DownloadBottomSheet({required this.onpress, this.view, Key? key})
      : super(key: key);
  AsyncCallback onpress;
  bool? view;
  @override
  State<DownloadBottomSheet> createState() => _DownloadBottomSheetState();
}

class _DownloadBottomSheetState extends State<DownloadBottomSheet> {  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: SizedBox(
          height: ScreenUtil().setHeight(250),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.view != true ? 'Download' : 'View',
                   style:TextStyle(
                                                fontFamily: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600)
                                                    .fontFamily,
                                                fontSize: 17.sp,
                                              ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                 widget.view == true ? 'Would you like to view the file': 'Would you like to download the file?',
                   style:TextStyle(
                                                fontFamily: GoogleFonts.inter(
                                                  color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w600)
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
                            side:  BorderSide(color: Colors.grey.shade200)),
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
                          'Yes , continue',
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
                      onPressed: widget.onpress,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
