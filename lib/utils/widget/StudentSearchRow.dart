// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/admin/Merits&Demerits/view_remarks.dart';
// Project imports:
import 'package:nextschool/screens/student/Profile.dart';
import 'package:nextschool/screens/student/StudentAttendance.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Student.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class StudentRow extends StatefulWidget {
  Student student;
  String? status;
  String? token;

  StudentRow(this.student, {this.status, this.token});

  @override
  _StudentRowState createState() =>
      _StudentRowState(student, status: status, token: token);
}

class _StudentRowState extends State<StudentRow> {
  Student student;
  String? status;
  String? token;

  _StudentRowState(this.student, {this.status, this.token});

  @override
  void initState() {
    print(student);
    super.initState();
  }

  ImageProvider<Object>? getImage() {
    if (student.photo != null && student.photo!.isNotEmpty) {
      // return NetworkImage(InfixApi().root + student.photo!);
      return CachedNetworkImageProvider(
        InfixApi().root + student.photo!,
      );
    } else {
      return const AssetImage('assets/images/parent.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    String image = student.photo == null || student.photo == ''
        ? 'http://saskolhmg.com/images/studentprofile.png'
        : InfixApi().root + student.photo!;
    return InkWell(
      onTap: () {
        if (status == 'remark') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewRemarks(
                id: student.sId.toString(),
              ),
            ),
          );
        } else if (status == 'attendance') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentAttendanceScreen(
                        id: student.uid,
                        token: token,
                        studentName: student.name,
                        studentGrade: student.className,
                        studentPhoto: student.photo,
                      )));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(
                id: student.uid.toString(),
              ),
            ),
          );
        }
      },
      splashColor: Colors.purple.shade200,
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.0.sp,
          right: 12.0.sp,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CircleAvatar(
                    backgroundImage: getImage(),
                    backgroundColor: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ((student.name.toString()).toLowerCase()).titleCase,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily:
                              GoogleFonts.inter(fontWeight: FontWeight.w600)
                                  .fontFamily,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Grade : ${student.className}',
                            style: TextStyle(
                              color: HexColor('#8a96a0'),
                              fontSize: 10.sp,
                              fontFamily:
                                  GoogleFonts.inter(fontWeight: FontWeight.w600)
                                      .fontFamily,
                            ),
                          ),
                          Utils.sizedBoxWidth(16),
                          (status == 'attendance')
                              ? getStatus(context, student.attendanceType)
                              : const SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.5.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget getStatus(BuildContext context, String? status) {
    if (status == 'L') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefc5),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Late',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFFc08b02),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    } else if (status == 'A') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefee),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Absent',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFFff8989),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    } else if (status == 'P') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFb7f6d3),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Present',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFF449e58),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    } /* else*/ /* if (status == 'C')*/ /* {
      return Container(
        decoration: BoxDecoration(
            color: Color(0xFFDCDCDC),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            '',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium.copyWith(
              color: Color(0xFF696969),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      );
    }*/
    else {
      // return SizedBox();
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Attendance not taken ',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
          ),
        ),
      );
    }
  }
}
