import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/grade_list_controller.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';
import '../utils/model/Classes.dart';
import '../utils/widget/date_selector_textfield.dart';

class ExportAttendanceScreen extends StatefulWidget {
  const ExportAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<ExportAttendanceScreen> createState() => _ExportAttendanceScreenState();
}

class _ExportAttendanceScreenState extends State<ExportAttendanceScreen> {
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  GradeListController _gradeListController = Get.put(GradeListController());
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  int? classId;
  String? errorMsg;
  String? fromDate;
  String? tillDate;
  String? _selectedClass;
  String? duration;
  bool _pdf = false;
  bool _excel = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Export Attendance',
      ),
      body: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => getClassNewDropdown(_gradeListController.gradeList)),
            const SizedBox(
              height: 20,
            ),
            getDurationDropdown(),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: duration == 'Custom Date',
              child: Column(children: [
                DateSelectorTextField(
                  maxDate: DateTime.now(),
                  controller: fromDateController,
                  onDateSelected: (date) {
                    fromDateController.text = date;
                    fromDate = date;
                  },
                  locale: _locale,
                  title: 'From',
                  validatorMessage: 'Please select from date',
                ),
                SizedBox(
                  height: 2.h,
                ),
                DateSelectorTextField(
                  maxDate: DateTime.now(),
                  controller: toDateController,
                  onDateSelected: (date) {
                    toDateController.text = date;
                    tillDate = date;
                  },
                  locale: _locale,
                  title: 'To',
                  validatorMessage: 'Please select from date',
                ),
                const SizedBox(
                  height: 20,
                )
              ]),
            ),

            Center(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: HexColor('#3bb28d')),
                    alignment: Alignment.center,
                    width: 40.w,
                    height: 45.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svg/Export.svg'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Export',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontFamily: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ).fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  if (classId != null &&
                      fromDate != null &&
                      tillDate != null &&
                      duration != null) {
                    export();
                  } else {
                    Utils.showToast('Please select every details');
                  }
                },
              ),
            ),
            // Text(
            //   'Download as',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 10.sp,
            //     fontFamily: GoogleFonts.inter(
            //       fontWeight: FontWeight.w500,
            //     ).fontFamily,
            //   ),
            // ),
            // SizedBox(
            //   height: 2.h,
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           setState(() {
            //             _pdf = true;
            //             _excel = false;
            //           });
            //         });
            //       },
            //       child: Container(
            //         height: 45,
            //         width: 45.w,
            //         decoration: BoxDecoration(
            //           color: _pdf ? HexColor('#3bb28d') : HexColor('#f8f8f8'),
            //           borderRadius: BorderRadius.circular(10),
            //           //border
            //           border: _pdf
            //               ? Border.all(
            //                   color: HexColor('#3bb28d'),
            //                   width: 1,
            //                 )
            //               : Border.all(
            //                   color: HexColor('#e3e3e3'),
            //                   width: 1,
            //                 ),
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Image.asset('assets/images/pdf1.png'),
            //             SizedBox(
            //               width: 1.w,
            //             ),
            //             FittedBox(
            //               child: Text(
            //                 'PDF',
            //                 style: TextStyle(
            //                   color:
            //                       _pdf ? Colors.white : HexColor('#939da6'),
            //                   fontSize: 12.sp,
            //                   fontFamily: GoogleFonts.inter(
            //                     fontWeight: FontWeight.w600,
            //                   ).fontFamily,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           setState(() {
            //             _excel = true;
            //             _pdf = false;
            //           });
            //         });
            //       },
            //       child: Container(
            //         height: 45,
            //         width: 45.w,
            //         decoration: BoxDecoration(
            //           color:
            //               _excel ? HexColor('#3bb28d') : HexColor('#f8f8f8'),
            //           borderRadius: BorderRadius.circular(10),
            //           //border
            //           border: _excel
            //               ? Border.all(
            //                   color: HexColor('#3bb28d'),
            //                   width: 1,
            //                 )
            //               : Border.all(
            //                   color: HexColor('#e3e3e3'),
            //                   width: 1,
            //                 ),
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Image.asset('assets/images/Excel.png'),
            //             SizedBox(
            //               width: 1.w,
            //             ),
            //             FittedBox(
            //               child: Text(
            //                 'Excel',
            //                 style: TextStyle(
            //                   color:
            //                       _excel ? Colors.white : HexColor('#939da6'),
            //                   fontSize: 12.sp,
            //                   fontFamily: GoogleFonts.inter(
            //                     fontWeight: FontWeight.w600,
            //                   ).fontFamily,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  export() async {
    var data = {
      'class_id': classId,
      'date_from': fromDate,
      'date_till': tillDate
    };
    log(data.toString());
    final response = await http.post(
        Uri.parse(InfixApi.exportAttendance(classId)),
        body: jsonEncode(data),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      //file bytes
      var bytes = response.bodyBytes;
      //file name
      var fileName = _selectedClass!+' Attendance';
      //save file
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      // the downloads folder path
     String tempPath = '/storage/emulated/0/Download';
      var filePath = tempPath + '/${fileName}.xlsx';
      final buffer = bytes.buffer;
      //save file
      try {
        await File(filePath).writeAsBytes(
            buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

        // view file using system default viewer
        OpenFile.open(filePath);
        Utils.showToast('File Saved at $filePath');
      } catch (e) {
        Utils.showToast('Error in downloading file');
      }
    }
  }

  Widget getClassNewDropdown(List<Classes> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Class',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>(
          validator: (value) {
            if (value == null) {
              return 'Please select a class';
            }
            return null;
          },
          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },
          items: classes.map((e) => e.name!).toList(),
          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  Divider(
                    color: HexColor('#8e9aa6'),
                    thickness: 0.5,
                  )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight:
                  (classes.length * 60) < 200 ? (classes.length * 60) : 200,
            ),
          ),
          clearButtonProps: const ClearButtonProps(
            isVisible: true,
            icon: Icon(Icons.clear),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              errorStyle: TextStyle(
                fontSize: 8.sp,
                color: HexColor('#de5151'),
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
          ),
          onChanged: (dynamic newValue) async {
            setState(() {
              errorMsg = '';
              _selectedClass = newValue;
              classId = getCode(classes, newValue);
            });
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: _selectedClass,
        ),
      ],
    );
  }

  int? getCode<T>(T t, String? title) {
    int? code;
    for (var cls in t as Iterable) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Widget getDurationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Attendance for*',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>(
          // mode: Mode.MENU,
          validator: (value) {
            if (value == null) {
              return 'Please select a Duration';
            }
            return null;
          },
          // showSelectedItems: true,
          items: ['Last Week', 'Last Month', 'Last Quarter', 'Custom Date'],

          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },
          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  item == 'Custom Date'
                      ? Container()
                      : Divider(
                          color: HexColor('#8e9aa6'),
                          thickness: 0.5,
                        )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (4 * 42.sp) < 170.sp ? (4 * 42.sp) : 170.sp,
            ),
          ),
          clearButtonProps: const ClearButtonProps(
            isVisible: true,
            icon: Icon(Icons.clear),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            dropdownSearchDecoration: InputDecoration(
              errorStyle: TextStyle(
                fontSize: 8.sp,
                color: HexColor('#de5151'),
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
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
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
            ),
          ),
          onChanged: (dynamic newValue) {
            ['Last Week', 'Last Month', 'Last Quarter', 'Custom Date'];
            setState(() {
              duration = newValue;
            });
            if (newValue == 'Last Week') {
              fromDate =
                  parseDate(DateTime.now().subtract(const Duration(days: 6)));
              tillDate = parseDate(DateTime.now());
            } else if (newValue == 'Last Month') {
              fromDate =
                  parseDate(DateTime.now().subtract(const Duration(days: 30)));
              tillDate = parseDate(DateTime.now());
            } else if (newValue == 'Last Quarter') {
              fromDate =
                  parseDate(DateTime.now().subtract(const Duration(days: 90)));
              tillDate = parseDate(DateTime.now());
            }
          },
          selectedItem: duration,
        ),
      ],
    );
  }
}

class SelectCard extends StatefulWidget {
  final String title;
  final bool value;
  // final Function(bool) onChanged;
  final AsyncCallback onChanged;

  const SelectCard({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {
  late bool _value;

  @override
  initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged();
        setState(() {});
      },
      child: Container(
        height: 45,
        width: 28.w,
        decoration: BoxDecoration(
          color: _value ? Colors.blueAccent : HexColor('#f8f8f8'),
          borderRadius: BorderRadius.circular(10),
          //border
          border: _value
              ? Border.all(
                  color: Colors.blueAccent,
                  width: 1,
                )
              : Border.all(
                  color: HexColor('#e3e3e3'),
                  width: 1,
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: _value ? Colors.white : HexColor('#939da6'),
                  fontSize: 8.sp,
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ).fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
