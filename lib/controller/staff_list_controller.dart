import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Staff.dart';

class StaffListController extends GetxController {
  var _staffs = <Staff>[].obs;
  var _totalCount = 0.obs;
  var _dataFetched = false.obs;

  //getter and setter
  List<Staff> get staffs => _staffs.value;
  int get totalCount => _totalCount.value;
  bool get dataFetched => _dataFetched.value;

  //function to reset the values
  void reset() {
    _staffs.value = <Staff>[];
    _totalCount.value = 0;
    _dataFetched.value = false;
  }

  //function to fetch data
  Future fetchData(int staffId) async {
    _dataFetched.value = false;
    log('fetching data');
    var _userDetailsController = Get.put(UserDetailsController());
    var token = _userDetailsController.token;
    var id = _userDetailsController.id.toString();
    final response = await http.get(Uri.parse(InfixApi.getAllStaff(staffId)),
        headers: Utils.setHeader(token));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var list = StaffList.fromJson(jsonData['data'] as List<dynamic>);
      _staffs.value = <Staff>[];
      _staffs.addAll(list.staffs);
      _totalCount.value = _staffs.length;
      _dataFetched.value = true;
      return list;
    } else {
      throw Exception('Failed to load');
    }
  }
}
