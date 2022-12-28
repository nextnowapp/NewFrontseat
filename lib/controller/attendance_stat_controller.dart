import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/extensions/dev_log.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';

class AttendanceStatController extends GetxController {
  var _totalLearners = 0.obs;
  var _totalBoys = 0.obs;
  var _totalGirls = 0.obs;
  var _totalBoysinClass = 0.obs;
  var _totalGirlsinClass = 0.obs;
  var _class = ''.obs;
  var _totalPresent = 0.obs;
  var _totalTeachers = 0.obs;
  var _todayAttendacePercentage = 0.0.obs;
  var _classAttendacePercentage = ''.obs;
  var _dataFetched = false.obs;
  //getter and setter
  int get totalLearners => _totalLearners.value;
  int get totalBoys => _totalBoys.value;
  int get totalGirls => _totalGirls.value;
  int get totalBoysinClass => _totalBoysinClass.value;
  int get totalGirlsinClass => _totalGirlsinClass.value;
  String get classs => _class.value;
  int get totalPresent => _totalPresent.value;
  int get totalTeachers => _totalTeachers.value;
  double get todayAttendacePercentage => _todayAttendacePercentage.value;
  String get classAttendacePercentage => _classAttendacePercentage.value;
  bool get dataFetched => _dataFetched.value;

  //function to reset the values
  void reset() {
    _totalLearners.value = 0;
    _totalBoys.value = 0;
    _totalGirls.value = 0;
    _totalBoysinClass.value = 0;
    _totalGirlsinClass.value = 0;
    _class.value = '';
    _totalPresent.value = 0;
    _totalTeachers.value = 0;
    _todayAttendacePercentage.value = 0;
    _classAttendacePercentage.value = '';
    _dataFetched.value = false;
  }

  //function to add subjects to the list
  fetchAttendanceStat() async {
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    var dio = Dio();
    InfixApi.principalDashboardMatrix(userDetailsController.id).apiLog;
    'Fetching attendance stat'.log;
    var response = await dio
        .get(InfixApi.principalDashboardMatrix(userDetailsController.id),
            options: Options(
                headers:
                    Utils.setHeader(userDetailsController.token.toString()),
                responseType: ResponseType.json))
        .catchError((e) {
      Utils.showErrorToast(e.response.data['message']);
    });
    if (response.statusCode == 200) {
      var jsonData = response.data['data'];
      print(jsonData);
      //set values to the variables
      _totalLearners.value = jsonData['total_number_students'];
      _totalBoys.value = jsonData['total_number_of_students_boys'];
      _totalGirls.value = jsonData['total_number_of_students_girls'];
      _totalBoysinClass.value = jsonData['total_boys_in_class'];
      _totalGirlsinClass.value = jsonData['total_girls_in_class'];
      _class.value = jsonData['class'];
      _totalPresent.value = _totalBoys.value + _totalGirls.value;
      _totalTeachers.value = jsonData['total_number_of_teachers'];
      _classAttendacePercentage.value =
          jsonData['class_attendance_percentage'].toString();
      _todayAttendacePercentage.value =
          (jsonData['total_number_of_students_present'] /
                  jsonData['total_number_students']) *
              100;
      _dataFetched.value = true;
    } else {
      throw Exception('Failed to load');
    }
  }
}
