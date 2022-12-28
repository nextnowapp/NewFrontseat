// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/UploadedContent.dart';
import 'package:nextschool/utils/widget/StudyMaterial_row.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class StudentOtherDownloads extends StatefulWidget {
  String? id;

  StudentOtherDownloads({this.id});

  @override
  _StudentOtherDownloadsState createState() => _StudentOtherDownloadsState();
}

class _StudentOtherDownloadsState extends State<StudentOtherDownloads> {
  Future<UploadedContentList?>? assignments;

  String? _token;
  String? _id;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    setState(() {
      _id = _userDetailsController.id.toString();
      assignments = fetchOtherDownloads(
          widget.id != null ? int.parse(widget.id!) : int.parse(_id!));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Other Downloads'),
      backgroundColor: const Color(0xFFF1F1F1),
      body: FutureBuilder<UploadedContentList?>(
        future: assignments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.uploadedContents.length > 0) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemCount: snapshot.data!.uploadedContents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StudyMaterialListRow(
                        snapshot.data!.uploadedContents[index]),
                  );
                },
              );
            } else {
              return Utils.noDataTextWidget();
            }
          } else {
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CustomLoader(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<UploadedContentList?>? fetchOtherDownloads(int id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentOtherDownloads(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return UploadedContentList.fromJson(jsonData['data']['uploadContents']);
    } else {
      throw Exception('failed to load');
    }
    return null;
  }
}
