// Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/LeaveDetailScreen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
// Project imports:
import 'package:nextschool/utils/model/Leave.dart';

// ignore: must_be_immutable
class LeaveRow extends StatefulWidget {
  Leave leave;
  void Function()? onPressed;

  LeaveRow(this.leave, {this.onPressed});

  @override
  State<LeaveRow> createState() => _LeaveRowState();
}

class _LeaveRowState extends State<LeaveRow> {
  // String formatDate(DateTime date) => new DateFormat("E, d MMM y").format(date);
  String formatDate(DateTime date) => new DateFormat('E, d MMM').format(date);
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.leave.type == null
                        ? 'not assigned'
                        : widget.leave.type!,
                    style: const TextStyle(
                        color: Color(0xFFb0b2b8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  getStatus(context, widget.leave.status),
                ],
              ),
              Utils.sizedBoxHeight(8),
              Text(
                formatDate(DateTime.parse(widget.leave.from!)) +
                    ' to ' +
                    formatDate(DateTime.parse(widget.leave.to!)),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Utils.sizedBoxHeight(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Applied on: ' +
                        formatDate(DateTime.parse(widget.leave.apply!)),
                    style: const TextStyle(
                        color: Color(0xFFb0b2b8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: widget.leave.status == 'P' ? true : false,
                        child: InkWell(
                          onTap: () {
                            deleteNoticePromptDialog(context, widget.leave.id);
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: const BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: const Icon(
                              Icons.delete,
                              color: Color(0xFFb0b2b8),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Utils.sizedBoxWidth(16),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LeaveDetailScreen(
                                        widget.leave,
                                      )));
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: const BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: const Icon(
                            Icons.navigate_next,
                            color: Color(0xFFb0b2b8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStatus(BuildContext context, String? status) {
    if (status == 'P') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefc5),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Pending',
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
    } else if (status == 'R') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefee),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Rejected',
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
    } else if (status == 'A') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFb7f6d3),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Approved',
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
    } else if (status == 'C') {
      return Container(
        decoration: const BoxDecoration(
            color: Color(0xFFffefee),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text(
            'Denied',
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
    } else {
      return Container();
    }
  }

  deleteNoticePromptDialog(BuildContext context, int? id) async {
    Widget cancelButton = TextButton(
      child: Text(
        'No',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontSize: ScreenUtil().setSp(14), color: Colors.white),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF4E88FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Center(
        child: Text(
          'Delete',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: ScreenUtil().setSp(14),
                height: 0.6,
                color: Colors.white,
              ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () async {
        //remove item from listview
        Navigator.of(context, rootNavigator: true).pop();

        try {
          final response = await http.get(
              Uri.parse(InfixApi.deleteAppliedLeave(widget.leave.id)),
              headers: Utils.setHeader(_token.toString()));
          if (response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            Utils.showToast('Leave Deleted Successfully');
          }
        } catch (e) {
          print(e);
          Utils.showToast(e.toString());
        }
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color(0xFF222744),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Are you sure, you want to delete the Leave?',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: yesButton,
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: cancelButton,
              ),
            ],
          )
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
