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
import 'package:nextschool/utils/model/Notice.dart';
import 'package:nextschool/utils/widget/NoticeRow.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  Future<NoticeList?>? notices;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? _token;

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notices = getNotices(_userDetailsController.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'School Notice'),
      backgroundColor: const Color(0xFFE1E1E1),
      body: FutureBuilder<NoticeList?>(
        future: notices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.notices);
            if (snapshot.data!.notices.length > 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: snapshot.data!.notices.length,
                  itemBuilder: (context, index) {
                    return NoticRowLayout(snapshot.data!.notices[index]);
                  },
                ),
              );
            } else {
              return Utils.noDataTextWidget();
            }
          } else {
            return const Center(
              child: CustomLoader(),
            );
          }
        },
      ),
    );
  }

  Future<NoticeList?>? getNotices(int id) async {
    final response = await http
        .get(Uri.parse(InfixApi.getNoticeUrl(id)),
            headers: Utils.setHeader(_token.toString()))
        .catchError((e) {
      var msg = e.response.data['message'];
      Utils.showErrorToast(msg);
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return NoticeList.fromJson(jsonData['data']['allNotices']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
