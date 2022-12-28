// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Child.dart';
import 'package:nextschool/utils/widget/ChildRow.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

class ChildListScreen extends StatefulWidget {
  @override
  _ChildListScreenState createState() => _ChildListScreenState();
}

class _ChildListScreenState extends State<ChildListScreen> {
  Future<ChildList?>? childs;
  String? _token;
  String? _id;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    childs = getAllStudent(_id!);
  }

  int? value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Child List',
      ),
      backgroundColor: HexColor('#eaeaea'),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ChildList?>(
              future: childs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //use gridview with card for profile pic and name
                  return ListView.builder(
                    itemCount: snapshot.data!.students.length,
                    itemBuilder: (context, index) {
                      return ChildRow(snapshot.data!.students[index], _token);
                    },
                  );
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
          ),
        ],
      ),
    );
  }

  Future<ChildList?>? getAllStudent(String? id) async {
    final response = await http
        .get(Uri.parse(InfixApi.getParentChildList(id)),
            headers: Utils.setHeader(_token.toString()))
        .catchError((e) {
      var msg = e.response.data['message'];
      Utils.showErrorToast(msg);
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ChildList.fromJson(jsonData['data']);
    } else if (response.statusCode == 500) {
      Utils.showErrorToast(response.body);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
