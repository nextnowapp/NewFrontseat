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
import 'package:nextschool/utils/model/ONlineExamResult.dart';
import 'package:nextschool/utils/widget/OnlineExamResultRow.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class OnlineExamResultScreen extends StatefulWidget {
  var id;

  OnlineExamResultScreen({this.id});

  @override
  _OnlineExamResultScreenState createState() => _OnlineExamResultScreenState();
}

class _OnlineExamResultScreenState extends State<OnlineExamResultScreen> {
  Future<OnlineExamResultList>? results;
  var id;
  dynamic code;
  var _selected;
  Future<OnlineExamNameList>? exams;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = widget.id != null ? widget.id : value;
        exams = getAllOnlineExam(id);
        exams!.then((val) {
          _selected = val.names.length != 0 ? val.names[0].title : '';
          code = val.names.length != 0 ? val.names[0].id : 0;
          results = getAllOnlineExamResult(id, code);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Result'),
      backgroundColor: Colors.white,
      body: FutureBuilder<OnlineExamNameList>(
        future: exams,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.names.length > 0) {
              return Column(
                children: <Widget>[
                  getDropdown(snapshot.data!.names),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Expanded(child: getExamResultList())
                ],
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

  Widget getDropdown(List<OnlineExamName> names) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: DropdownButton(
        elevation: 0,
        isDense: true,
        isExpanded: true,
        iconSize: 40,
        underline: Container(
          height: 1,
          color: Colors.transparent,
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        items: names.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: const Color(0xff415094), fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: const Color(0xff415094), fontSize: 15.0),
        onChanged: (dynamic value) {
          setState(() {
            _selected = value;

            code = getExamCode(names, value);

            debugPrint('User select $code');

            results = getAllOnlineExamResult(id, code);

            getExamResultList();
          });
        },
        value: _selected,
      ),
    );
  }

  Future<OnlineExamResultList> getAllOnlineExamResult(
      var id, dynamic code) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentOnlineActiveExamResult(id, code)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamResultList.fromJson(jsonData['data']['exam_result']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<OnlineExamNameList> getAllOnlineExam(var id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentOnlineActiveExamName(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamNameList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  dynamic getExamCode(List<OnlineExamName> names, String? title) {
    dynamic code;
    for (OnlineExamName name in names) {
      if (name.title == title) {
        code = name.id;
        break;
      }
    }
    return code;
  }

  Widget getExamResultList() {
    return FutureBuilder<OnlineExamResultList>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.results.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return OnlineExamResultRow(snapshot.data!.results[index]);
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
    );
  }
}
