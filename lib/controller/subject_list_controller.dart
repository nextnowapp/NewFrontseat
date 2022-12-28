import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/TeacherSubject.dart';

class SubjectListController extends GetxController {
  var _subjectList = <TeacherSubject>[].obs;

  //getter and setter
  List<TeacherSubject> get subjectList => _subjectList.value;

  //function to reset the values
  void reset() {
    _subjectList.value = <TeacherSubject>[];
  }

  //function to add subjects to the list
  void fetchSubjectList() async {
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    final response = await http.get(Uri.parse(InfixApi.subjectList),
        headers: Utils.setHeader(userDetailsController.token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      TeacherSubjectList subjectList =
          TeacherSubjectList.fromJson(jsonData['data']);
      _subjectList.value = subjectList.subjects;
    } else {
      throw Exception('Failed to load');
    }
  }
}
