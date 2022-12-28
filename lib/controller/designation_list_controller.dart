import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/model/designation_model.dart';

import '../utils/Utils.dart';
import '../utils/apis/Apis.dart';

class DesignationListController extends GetxController {
  var _designationList = <DesignationData>[].obs;

  //getter and setter
  List<DesignationData> get designationList => _designationList.value;

  //function to reset the values
  void reset() {
    _designationList.value = <DesignationData>[];
  }

  //function to add grades to the list
  void fetchDesignationList() async {
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    final response = await http.get(Uri.parse(InfixApi.getAllDesignations()),
        headers: Utils.setHeader(userDetailsController.token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      DesignationModel designations = DesignationModel.fromJson(jsonData);
      _designationList.value = designations.data!;
    } else {
      throw Exception('Failed to load');
    }
  }
}
