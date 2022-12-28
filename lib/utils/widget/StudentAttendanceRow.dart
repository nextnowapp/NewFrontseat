// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/attendance_list_controller.dart';
// Package imports:
// Project imports:
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/custom_widgets/CustomRadioButton/CustomButton/ButtonTextStyle.dart';
import 'package:nextschool/utils/custom_widgets/CustomRadioButton/custom_radio_button.dart';
import 'package:nextschool/utils/model/GlobalClass.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class StudentAttendanceRow extends StatefulWidget {
  // Student student;
  int index;
  StudentAttendanceRow(this.index);

  @override
  _StudentAttendanceRowState createState() => _StudentAttendanceRowState(index);
}

class _StudentAttendanceRowState extends State<StudentAttendanceRow> {
  bool isSelected = true;
  int? mClass;
  int index;
  String? date;
  var function = GlobalDatae();
  Future<bool>? isChecked;
  String? token;
  late Color selectedColor;
  Future? getAttend;
  String? url;
  AttendanceListController attendanceListController =
      Get.put(AttendanceListController());

  _StudentAttendanceRowState(this.index);

  @override
  Widget build(BuildContext context) {
    if (attendanceListController.attendanceList[index].attendanceStatus ==
        'P') {
      selectedColor = HexColor('#c3f3e5');
    } else if (attendanceListController
            .attendanceList[index].attendanceStatus ==
        'A') {
      selectedColor = HexColor('#ffdce1');
    } else if (attendanceListController
            .attendanceList[index].attendanceStatus ==
        'L') {
      selectedColor = HexColor('#ffeec4');
    } else {
      selectedColor = Colors.white;
    }

    String image =
        attendanceListController.attendanceList[index].photo == null ||
                attendanceListController.attendanceList[index].photo == ''
            ? 'http://saskolhmg.com/images/studentprofile.png'
            : InfixApi().root +
                attendanceListController.attendanceList[index].photo!;
    return InkWell(
      onTap: () {
        setState(() {
          // isSelected = !isSelected;
          // atten = isSelected ? 'P' : 'A';
          // isSelected ? function.sub() : function.add();
          // setAttendance();
        });
      },
      // splashColor: Colors.purple.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.only(left: 5, right: 20, top: 10),
            leading: !isSelected
                ? CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.red.shade700,
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                  )
                : CircleAvatar(
                    // radius: 50.0,
                    backgroundImage: NetworkImage(image),
                    maxRadius: 40,
                    backgroundColor: Colors.grey,
                  ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    attendanceListController.attendanceList[index].name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                    // style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Text(
                  'Class : ${attendanceListController.attendanceList[index].className}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomRadioButton(
              selectedBorderColor: selectedColor,
              unSelectedBorderColor: HexColor('#8395ae'),
              defaultSelected: attendanceListController
                      .attendanceList[index].attendanceType ??
                  attendanceListController
                      .attendanceList[index].attendanceStatus,
              elevation: 0,
              unSelectedColor: Theme.of(context).canvasColor,
              icons: [
                Icon(
                  Icons.check,
                  size: 18,
                  color: (isSelected ? Colors.white : HexColor('#8395ae')),
                ),
                Icon(Icons.close_rounded,
                    size: 18,
                    color: (isSelected ? Colors.white : HexColor('#8395ae'))),
                Icon(Icons.error_outline,
                    size: 18,
                    color: (isSelected ? Colors.white : HexColor('#8395ae'))),
              ],
              buttonLables: [
                'Present',
                'Absent',
                'Late',
                // 'Half Day',
              ],
              buttonValues: [
                'P',
                'A',
                'L',
                // "H",
              ],
              buttonTextStyle: ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: HexColor('#8395ae'),
                  // selectedColor: Colors.green,
                  // unSelectedColor: const Color(0xff415094),
                  textStyle: TextStyle(fontSize: ScreenUtil().setSp(14))),
              radioButtonValue: (dynamic value) {
                if (value == 'P' &&
                    attendanceListController
                            .attendanceList[index].attendanceStatus ==
                        'A') {
                  attendanceListController.decrementAbsentCount();
                  attendanceListController.incrementPresentCount();
                } else if (value == 'A' &&
                    attendanceListController
                            .attendanceList[index].attendanceStatus ==
                        'P') {
                  attendanceListController.decrementPresentCount();
                  attendanceListController.incrementAbsentCount();
                } else if (value == 'L' &&
                    attendanceListController
                            .attendanceList[index].attendanceStatus ==
                        'A') {
                  attendanceListController.decrementAbsentCount();
                  attendanceListController.incrementLateCount();
                } else if (value == 'L' &&
                    attendanceListController
                            .attendanceList[index].attendanceStatus ==
                        'P') {
                  attendanceListController.decrementPresentCount();
                  attendanceListController.incrementLateCount();
                } else if (value == 'A' &&
                    attendanceListController
                            .attendanceList[index].attendanceStatus ==
                        'L') {
                  attendanceListController.decrementLateCount();
                  attendanceListController.incrementAbsentCount();
                } else if (value == 'P' &&
                    attendanceListController
                            .attendanceList[index].attendanceStatus ==
                        'L') {
                  attendanceListController.decrementLateCount();
                  attendanceListController.incrementPresentCount();
                }

                //update the attendance status
                setState(() {
                  if (attendanceListController
                          .attendanceList[index].attendanceStatus !=
                      value) {
                    attendanceListController
                        .attendanceList[index].attendanceStatus = value;
                    attendanceListController
                        .attendanceList[index].attendanceType = value;
                  }
                });
              },
              selectedColor: selectedColor,
              enableShape: true,
              customShape: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              horizontal: false,
              width: ScreenUtil().setWidth(77),
              height: ScreenUtil().setHeight(25),
              enableButtonWrap: false,
              wrapAlignment: WrapAlignment.start,
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 10.0),
            color: Colors.grey[200],
          )
        ],
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          const CustomLoader(),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
