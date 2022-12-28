import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';

class NotificationController extends GetxController {
  var _unreadNotificationCount = 0.obs;
  var _dataFetched = false.obs;

  int get unreadNotificationCount => _unreadNotificationCount.value;
  bool get dataFetched => _dataFetched.value;

  void reset() {
    _unreadNotificationCount.value = 0;
    _dataFetched.value = false;
  }

  void fetchUnreadNotificationCount() async {
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    var id = userDetailsController.id;
    var token = userDetailsController.token.toString();

    final response = await http.get(Uri.parse(InfixApi.getMyNotifications(id)),
        headers: Utils.setHeader(token));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var notifications = jsonData['data'];
      _unreadNotificationCount.value = notifications['unread_notification'];
      _dataFetched.value = true;
    } else {
      throw Exception('Failed to load');
    }
  }
}
