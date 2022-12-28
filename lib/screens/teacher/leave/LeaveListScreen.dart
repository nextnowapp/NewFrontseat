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
import 'package:nextschool/utils/model/Leave.dart';
import 'package:nextschool/utils/widget/Leave_row.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  Future<LeaveList?>? leaves;
  String? _token;
  String? _id;
  var indicator = new GlobalKey<RefreshIndicatorState>();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    leaves = fetchLeave(int.parse(_id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'My Leaves'),
      backgroundColor: Colors.white,
      body: FutureBuilder<LeaveList?>(
        future: leaves,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.leaves.length == 0) {
              return Utils.noDataTextWidget();
            } else
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    leaves = fetchLeave(int.parse(_id.toString()));
                  });
                },
                child: ListView.builder(
                  itemCount: snapshot.data!.leaves.length,
                  itemBuilder: (context, index) {
                    return LeaveRow(
                      snapshot.data!.leaves[index],
                      onPressed: () => indicator.currentState!.show(),
                    );
                  },
                ),
              );
          } else {
            return const Center(
              child: CustomLoader(),
            );
          }
        },
      ),
    );
  }

  Future<LeaveList?>? fetchLeave(int id) async {
    print(InfixApi.getLeaveList(id));
    final response = await http.get(Uri.parse(InfixApi.getLeaveList(id)),
        headers: Utils.setHeader(_token.toString()));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveList.fromJson(jsonData['data']['leave_list']);
    } else {
      throw Exception('failed to load');
    }
    return null;
  }
}
