import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/AssignLearningArea/subject_list_model.dart';
import 'package:nextschool/screens/admin/Academics/LearningAreas/add_learning_area.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:nextschool/utils/widget/edit_bottomsheet.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/widget/customLoader.dart';

class LearningAreaList extends StatefulWidget {
  const LearningAreaList({Key? key}) : super(key: key);

  @override
  _LearningAreaListState createState() => _LearningAreaListState();
}

class _LearningAreaListState extends State<LearningAreaList> {
  String? _token;
  Future<SubjectListModel?>? model;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;

    model = fetchLearningAreas();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Learning Area List',
      ),
      body: FutureBuilder<SubjectListModel?>(
        future: model,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.data!.length == 0) {
              return Center(
                  child: Utils.noDataImageWidgetWithText(
                      'No Learning Areas Found'));
            } else {
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Utils.sizedBoxHeight(16);
                  },
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.data![index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                ' Type: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                data.subjectType! == 'T'
                                    ? 'Theory'
                                    : data.subjectType! == 'P'
                                        ? 'Practical'
                                        : 'Theory & Practical',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(8),
                          Utils.sizedBoxHeight(8),
                          Row(
                            children: [
                              const Text(
                                'Learning Area: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                              Expanded(
                                child: Text(
                                  data.subjectName!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Utils.sizedBoxHeight(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      custom_modal_bottom_sheet
                                          .showCupertinoModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(100),
                                                topLeft: Radius.circular(100))),
                                        isDismissible: false,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return EditBottomSheet(
                                              onEdit: () async {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddLearningArea(
                                                          isEdit: true,
                                                          model: data,
                                                        )));
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF3F3F3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 14,
                                        // color: Color(0xFFb0b2b8),
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Edit',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 12.sp,
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        deleteNoticePromptDialog(
                                            context, data.id);
                                      });
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFF3F3F3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: const Icon(
                                        Icons.delete,
                                        size: 14,
                                        // color: Color(0xFFb0b2b8),
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Delete',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            }
          } else
            return const Center(
              child: CustomLoader(),
            );
        },
      ),
    );
  }

  Future<SubjectListModel?>? fetchLearningAreas() async {
    final response = await http.get(Uri.parse(InfixApi.learningAreaList()),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SubjectListModel.fromJson(jsonData);
    } else {
      throw Exception('failed to load');
    }
    return null;
  }

  editNoticePromptDialog(BuildContext context, Subject list) async {
    Widget cancelButton = TextButton(
      child: Text(
        'No',
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(fontSize: 14.sp, color: Colors.white),
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
          'Edit',
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontSize: 14.sp,
                height: 0.6,
                color: Colors.white,
              ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddLearningArea(
                      isEdit: true,
                      model: list,
                    )));
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
          Text('Are you sure, you want to edit the Learning Area?',
              style: TextStyle(
                  fontSize: 16.sp,
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

  deleteNoticePromptDialog(BuildContext context, int? id) async {
    return custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DeleteBottomSheet(
          onDelete: () async {
            Utils.showProcessingToast();
            final response = await http.get(
                Uri.parse(InfixApi.deleteLearningArea(id.toString())),
                headers: Utils.setHeader(_token.toString()));
            if (response.statusCode == 200) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // Utils.showSnackBar(context, 'Learning Area Deleted Successfully',
              //     color: Colors.green);
              Utils.showToast('Learning Area Deleted Successfully');
            } else {
              throw Exception('Failed to load');
            }
          },
          title: 'Delete Learning Area',
        );
      },
    );
  }
}
