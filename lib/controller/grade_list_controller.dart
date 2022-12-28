import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Classes.dart';

class GradeListController extends GetxController {
  var _gradeList = <Classes>[].obs;

  //getter and setter
  List<Classes> get gradeList => _gradeList.value;

  //function to reset the values
  void reset() {
    _gradeList.value = <Classes>[];
  }

  //function to add grades to the list
  void fetchGradeList() async {
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    final response = await http.get(Uri.parse(InfixApi.getClassById()),
        headers: Utils.setHeader(userDetailsController.token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var classList = ClassList.fromJson(jsonData['data']['classes']);
      this._gradeList.value = classList.classes;
    }
    return null;
  }
}
