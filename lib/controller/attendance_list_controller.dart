import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/extensions/dev_log.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/model/Attendance.dart';

class AttendanceListController extends GetxController {
  var _attendanceList = <Attendance>[].obs;
  var _totalCount = 0.obs;
  var _totalPresent = 0.obs;
  var _totalAbsent = 0.obs;
  var _totalLate = 0.obs;
  var _dataFetched = false.obs;

  var _absentStudentList = ''.obs;
  var _presentStudentList = ''.obs;
  var _lateStudentList = ''.obs;

  //getter and setter
  List<Attendance> get attendanceList => _attendanceList.value;
  int get totalCount => _attendanceList.value.length;
  int get totalPresentCount => _totalPresent.value;
  int get totalAbsentCount => _totalAbsent.value;
  int get totalLateCount => _totalLate.value;
  bool get dataFetched => _dataFetched.value;
  String get absentStudentList => _absentStudentList.value;
  String get presentStudentList => _presentStudentList.value;
  String get lateStudentList => _lateStudentList.value;

  //function to reset the values
  void reset() {
    _attendanceList.value = <Attendance>[];
    _totalPresent.value = 0;
    _totalAbsent.value = 0;
    _totalLate.value = 0;
    _dataFetched.value = false;
    _absentStudentList.value = '';
    _presentStudentList.value = '';
    _lateStudentList.value = '';
  }

  //function to increment present count
  void incrementPresentCount() {
    _totalPresent.value++;
  }

  //function to increment absent count
  void incrementAbsentCount() {
    _totalAbsent.value++;
  }

  //function to increment late count
  void incrementLateCount() {
    _totalLate.value++;
  }

  //function to decrement present count
  void decrementPresentCount() {
    _totalPresent.value--;
  }

  //function to decrement absent count
  void decrementAbsentCount() {
    _totalAbsent.value--;
  }

  //function to decrement late count
  void decrementLateCount() {
    _totalLate.value--;
  }

  //function to get the presnt, absent and late student in comma separated string
  void getStatus() {
    List presentStudentList = [];
    List absentStudentList = [];
    List lateStudentList = [];

    // get the presnt, absent and late student in respective list
    for (var attendance in _attendanceList) {
      if (attendance.attendanceStatus == 'A') {
        absentStudentList.add(attendance.sId);
      } else if (attendance.attendanceStatus == 'P') {
        presentStudentList.add(attendance.sId);
      } else if (attendance.attendanceStatus == 'L') {
        lateStudentList.add(attendance.sId);
      }
    }

    // convert the list to comma separated string
    _absentStudentList.value = absentStudentList.join(',');
    _presentStudentList.value = presentStudentList.join(',');
    _lateStudentList.value = lateStudentList.join(',');
  }

  void fetchStudentList(String url) async {
    reset();
    UserDetailsController userDetailsController =
        Get.put(UserDetailsController());
    var dio = Dio();
    (url).apiLog;
    'Fetching attendance list'.log;
    var response = await dio
        .get(url,
            options: Options(
                headers:
                    Utils.setHeader(userDetailsController.token.toString()),
                responseType: ResponseType.json))
        .catchError((e) {
      Utils.showErrorToast(e.response.data['message']);
    });

    if (response.statusCode == 200) {
      var jsonData = response.data['data'];
      _attendanceList.value = AttendanceList.fromJson(jsonData).attendances;
      _totalCount.value = _attendanceList.value.length;

      //check status of each attendance and increment the count
      _attendanceList.forEach((element) {
        if (element.attendanceStatus == 'P') {
          incrementPresentCount();
        } else if (element.attendanceStatus == 'A') {
          incrementAbsentCount();
        } else if (element.attendanceStatus == 'L') {
          incrementLateCount();
        }
      });
      _dataFetched.value = true;
    } else {
      throw Exception('Failed to load');
    }
  }
}
