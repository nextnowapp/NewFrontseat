import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/model/ProfileModel.dart';

UserDetailsController _userDetailsController = Get.put(UserDetailsController());

class InfixApi {

  String root = _userDetailsController.schoolUrl;
  static String baseApi = _userDetailsController.schoolUrl + 'api/';
  static String baseUrl = _userDetailsController.schoolUrl;

  // static String AppConfig.domainName + 'api/' = root + 'api/';

  static String submitApproval = baseUrl + 'api/add_signup_approval_reuqest';
  static String searchSchool = baseUrl + 'api/' + 'search_schoool';
  static String saveParentDetails = baseUrl + 'api/' + 'save_parent_detail';
  static String saveLearnerDetails = baseUrl + 'api/' + 'save_learner_detail';
  static String checkRegistrationStatus =
      baseUrl + 'api/' + 'check_registration_status';
  static String uploadHomework = baseUrl + 'api/' + 'add-homework';
  static String updateHomework = baseUrl + 'api/' + 'update-homework';

  static String bookList = baseUrl + 'api/' + 'book-list';

  static String uploadContent = baseUrl + 'api/' + 'teacher-upload-content';
  static String uploadProfilePicture = baseUrl + 'api/' + 'staff-profile-pic';
  static String uploadParentProfilePicture =
      baseUrl + 'api/' + 'parent-profile-pic';
  static String currentPermission =
      baseUrl + 'api/' + 'privacy-permission-status';
  static String createVirtualClass = 'zoom/create-virtual-class';
  static String createVirtualClassUrl = 'zoom-class-room';
  static String zoomMakeMeeting = 'zoom-make-meeting';
  static String zoomMakeMeetingUrl = 'zoom-meeting-room';

  // static String login(String email, String password) {
  //   return AppConfig.domainName + 'api/' + 'login?email=' + email + '&password=' + password;
  // }
  static String gradeWiseStudentsCount =
      baseUrl + 'api/' + 'grade_wise_students_count';

  static String login(String email, String password) {
    return baseUrl + 'api/' + 'login?email=' + email + '&password=' + password;
  }

  static String login2() {
    return baseUrl + 'api/' + 'login_with_dob';
  }

  static String updateMobile() {
    return baseUrl + 'api/' + 'update-mobile';
  }

  static String getRoutineUrl(int id) {
    return baseUrl + 'api/' + 'student-class-routine/$id';
  }

  static String classWiseRoutine(int id) {
    return baseUrl + 'api/' + 'student-class-routine/$id';
  }

  static String classWiseTimetable() {
    return baseUrl + 'api/' + 'class-routine-new';
  }

  static String classWiseTimetablenew() {
    return baseUrl + 'api/' + 'class-time';
  }

  static String getStudenthomeWorksUrl(int id) {
    return baseUrl + 'api/' + 'student-homework/?id=$id';
  }

  static String getSubjectsUrl(int id) {
    return baseUrl + 'api/' + 'studentSubject/$id';
  }

  static String getStudentTeacherUrl(int? id) {
    return baseUrl + 'api/' + 'studentTeacher/$id';
  }

  static String getTeacherPhonePermission(int mPerm) {
    return baseUrl + 'api/' + 'privacy-permission/$mPerm';
  }

  static String getStudentIssuedBook(int id) {
    return baseUrl + 'api/' + 'student-library/$id';
  }

  static String getNoticeUrl(int id) {
    return baseUrl + 'api/' + 'student-noticeboard/$id';
  }

  static String getAdminNotice() {
    return baseUrl + 'api/' + 'notice-list';
  }

  static String getNews(var id) {
    return baseUrl + 'api/' + 'district-news-list';
  }

  static String getNewsDetails(int id) {
    return baseUrl + 'api/' + 'district-news-details/$id';
  }

  static String getStudentTimeline(int id) {
    return baseUrl + 'api/' + 'student-timeline/$id';
  }

  static String getStudentClassExamName(var id) {
    return baseUrl + 'api/' + 'exam-list/$id';
  }

  static String getStudentClsExamShedule(var id, int? code) {
    return baseUrl + 'api/' + 'exam-schedule/$id/$code';
  }

  static String getTeacherAttendence(int? id, int month, int year) {
    return baseUrl + 'api/' + 'my-attendance/$id?month=$month&year=$year';
  }

  static String getStudentAttendence(var id, int month, int year) {
    return baseUrl +
        'api/' +
        'student-my-attendance/$id?month=$month&year=$year';
  }

  static String getStudentOnlineResult(int id, int examId) {
    return baseUrl + 'api/' + 'online-exam-result/$id/$examId';
  }

  static String getChildDashboard(var id) {
    return baseUrl + 'api/' + 'childDashboard/$id';
  }

  static String getStudentClassExamResult(var id, int? examId) {
    return baseUrl + 'api/' + 'exam-result/$id/$examId';
  }

  static String getStudentByClass(int mClass) {
    return baseUrl + 'api/' + 'search-student?class=$mClass';
  }

  static String getStudentByName(String name) {
    return baseUrl + 'api/' + 'search-student?name=$name';
  }

  static String getStudentByRoll(String roll) {
    return baseUrl + 'api/' + 'search-student?roll_no=$roll';
  }

  static String getStudentbyTeacher(int id) {
    return baseUrl + 'api/' + 'view_assign_class_attendance?staff_user_id=$id';
  }

  static String getStudentByClassAndSection(int? mClass, {String? date}) {
    String url = baseUrl + 'api/' + 'search-student?class=$mClass';
    if (date != null) {
      url = url + '&date=$date';
    }
    return url;
  }

  static String getStudentByNameattendance(String? name, {String? date}) {
    String url = baseUrl + 'api/' + 'search-student?name=$name';
    if (date != null) {
      url = url + '&date=$date';
    }
    return url;
  }

  static String getAllStaff(int? id) {
    return baseUrl + 'api/' + 'staff-list';
  }

  static String teacherAttendanceReport() {
    return baseUrl + 'api/' + 'get_class_teacher_attendance_detail_report';
  }

  static String getAllSubject() {
    return baseUrl + 'api/' + 'subject';
  }

  static String getSectionById(int id, int? classId) {
    return baseUrl + 'api/' + 'teacher-section-list?id=$id&class=$classId';
  }

  static String getClassTimeType() {
    return baseUrl + 'api/' + 'class-time-type';
  }

  static String updateManagementProfile() {
    return baseUrl + 'api/' + 'update-management-profile';
  }

  static String sendBulkSMS() {
    return baseUrl + 'api/' + 'send-smsbulk';
  }

  static String assignClassTeacher() {
    return baseUrl + 'api/' + 'assign-class-teacher';
  }

  static String subjectStore() {
    return baseUrl + 'api/' + 'subject-store';
  }

  static String classStore() {
    return baseUrl + 'api/' + 'class-store';
  }

  static String updateSubject() {
    return baseUrl + 'api/' + 'subject-update';
  }

  static String saveClassTime() {
    return baseUrl + 'api/' + 'class-time';
  }

  static String classTimeUpdate() {
    return baseUrl + 'api/' + 'class-time-update';
  }

  static String assignClassRoom() {
    return baseUrl + 'api/' + 'class-room';
  }

  static String addStaff() {
    return baseUrl + 'api/' + 'staff-add';
  }

  static String addLearner() {
    return baseUrl + 'api/' + 'student-store';
  }

  static String deleteLearner(String id) {
    return baseUrl + 'api/' + 'student-delete/$id';
  }

  static String updateLearner() {
    return baseUrl + 'api/' + 'student-update';
  }

  static String updateParentProfile() {
    return baseUrl + 'api/' + 'parent-profile-update';
  }

  static String updateStaffProfile() {
    return baseUrl + 'api/' + 'staff-profile-update';
  }

  static String learnerPhoto() {
    return baseUrl + 'api/' + 'student-profile-pic';
  }

  static String staffPhoto() {
    return baseUrl + 'api/' + 'staff-profile-pic';
  }

  static String updateStaff() {
    return baseUrl + 'api/' + 'staff-update';
  }

  static String assignSection() {
    return baseUrl + 'api/' + 'section-store';
  }

  static String sectionList() {
    return baseUrl + 'api/' + 'section';
  }

  static String classList() {
    return baseUrl + 'api/' + 'class';
  }

  static String learningAreaList() {
    return baseUrl + 'api/' + 'subject';
  }

  static String updateClassRoom() {
    return baseUrl + 'api/' + 'class-room-update';
  }

  static String updateSection() {
    return baseUrl + 'api/' + 'section-update';
  }

  static String updateGrade() {
    return baseUrl + 'api/' + 'class-update';
  }

  static String deleteClassTime(String id) {
    return baseUrl + 'api/' + 'class-times/$id';
  }

  static String deleteLearningArea(String id) {
    return baseUrl + 'api/' + 'subject-delete/$id';
  }

  static String deleteClassRoom(String id) {
    return baseUrl + 'api/' + 'class-rooms/$id';
  }

  static String deleteSection(String id) {
    return baseUrl + 'api/' + 'section-delete/$id';
  }

  static String deleteStaff(String id) {
    return baseUrl + 'api/' + 'staff-delete/$id';
  }

  static String deleteGrade(String id) {
    return baseUrl + 'api/' + 'class-delete/$id';
  }

  static String updateStudentProfile() {
    return baseUrl + 'api/' + 'update-student-profile';
  }

  static String getClassById() {
    return baseUrl + 'api/' + 'teacher-class-list';
  }

  static String getChildren(String? id) {
    return baseUrl + 'api/' + 'childInfo/$id';
  }

  static String getTeacherSubject(int id) {
    return baseUrl + 'api/' + 'subject/$id';
  }

  static String getTeacherMyRoutine(int id) {
    return baseUrl + 'api/' + 'my-routine/$id';
  }

  static String staffClassUpdate() {
    return baseUrl + 'api/' + 'staff-class-update';
  }

  static String staffSubjectUpdate() {
    return baseUrl + 'api/' + 'staff-subject-update';
  }

  static String getRoutineByClassAndSection(
      int id, int? mClass, int? mSection) {
    return baseUrl + 'api/' + 'section-routine/$id/$mClass/$mSection';
  }

  static String getAllContent(String? id) {
    return baseUrl + 'api/' + 'content-list/$id';
  }

  static String getStaffContent() {
    return baseUrl + 'api/' + 'staff-content-list';
  }

  static String getAllDesignations() {
    return baseUrl + 'api/' + 'designation';
  }

  static String deleteContent(int? id) {
    return baseUrl + 'api/' + 'delete-content/$id';
  }

  static String deletHomework(int? id) {
    return baseUrl + 'api/' + 'delete-homework?homework_id=$id';
  }

  static String markAttendance() {
    return baseUrl + 'api/all-student-attendance';
  }

  static String attendanceCheck(String? date, int? mClass) {
    return baseUrl +
        'api/' +
        'student-attendance-check?date=$date&class=$mClass';
  }

  static String attendanceChcekName(String? date, String? name) {
    return baseUrl + 'api/' + 'student-attendance-check?date=$date&name=$name';
  }

  static String about = baseUrl + 'api/' + 'parent-about';

  static String getHomeWorkListUrl(int id) {
    return baseUrl + 'api/' + 'homework-list/$id';
  }

  static String getLeaveList(int id) {
    return baseUrl + 'api/' + 'staff-apply-list/$id';
  }

  static String staffDeleteLeave(int id) {
    return baseUrl + 'api/' + 'staff-delete/$id';
  }

  static String staffPendingLeave() {
    return baseUrl + 'api/' + 'staff-pending-leave';
  }

  static String staffApprovedLeave() {
    return baseUrl + 'api/' + 'staff-approved-leave';
  }

  static String staffRejectedLeave() {
    return baseUrl + 'api/' + 'staff-rejected-leave';
  }

  static String getParentChildList(String? id) {
    return baseUrl + 'api/' + 'child-list/$id';
  }

  static String getStudentOnlineActiveExam(var id) {
    return baseUrl + 'api/' + 'student-online-exam/$id';
  }

  static String getStudentOnlineActiveExamName(var id) {
    return baseUrl + 'api/' + 'choose-exam/$id';
  }

  static String getStudentOnlineActiveExamResult(var id, var examId) {
    return baseUrl + 'api/' + 'online-exam-result/$id/$examId';
  }

  static String getMeeting({uid, param}) {
    return baseUrl + 'api/' + '$param/user_id/$uid';
  }

  static String getMeetingUrl({mid, uid, param}) {
    return baseUrl + 'api/' + '$param/meeting_id/$mid/user_id/$uid';
  }

  static String getJoinMeetingUrlApp({mid}) {
    // return 'https://zoom.us/wc/$mid/start';
    // return 'https://zoom.us/wc/$mid/join?prefer=1'; // web
    return 'zoomus://zoom.us/join?confno=$mid'; // android
  }

  static String getJoinMeetingUrlWeb({mid}) {
    // return 'https://zoom.us/wc/$mid/start';
    return 'https://zoom.us/wc/$mid/join?prefer=1';
  }

  static String getUserApprovalStatus() {
    return baseUrl + 'api/' + 'all_pending_signup';
  }

  static String getUserApprovalDetails() {
    return baseUrl + 'api/' + 'signup_Request_Details';
  }

  static String userStatusUpdate() {
    return baseUrl + 'api/' + 'update_pending_signup';
  }

  static String getAllBirthday(String? id) {
    return baseUrl + 'api/' + 'upcoming-birthday/$id';
  }

  //events
  static String getEvents() {
    return baseUrl + 'api/event';
  }

  static String addEvent() {
    return baseUrl + 'api/add-event';
  }

  static String updateEvent() {
    return baseUrl + 'api/event-update';
  }

  static String deleteEvent(int id) {
    return baseUrl + 'api/delete-event/$id';
  }

  static String addMerit() {
    return baseUrl + 'api/merit-demerit-add';
  }

  static String updateMerit() {
    return baseUrl + 'api/merit-demerit-update';
  }

  static String deleteMerit(int id) {
    return baseUrl + 'api/merit-demerit-delete/$id';
  }

  static String getAllMerits(String id) {
    return baseUrl + 'api/merit-demerit-count/$id';
  }

  static String addBook(
      String title,
      String categoryId,
      String bookNo,
      String isbn,
      String publisherName,
      String authorName,
      String subjectId,
      String reckNo,
      String quantity,
      String price,
      String details,
      String date,
      String? userId,
      String? schoolId) {
    return baseUrl +
        'api/' +
        'save-book-data?book_title=' +
        title +
        '&book_category_id=' +
        categoryId +
        '&book_number=' +
        bookNo +
        '&isbn_no=' +
        isbn +
        '&publisher_name=' +
        publisherName +
        '&author_name=' +
        authorName +
        '&subject_id=' +
        subjectId +
        '&rack_number=' +
        reckNo +
        '&quantity=' +
        quantity +
        '&book_price=' +
        price +
        '&details=' +
        details +
        '&post_date=' +
        date +
        '&user_id=$userId&school_id=$schoolId';
  }

  static String adminAddBook = baseUrl + 'api/' + 'save-book-data';

  static String addLibraryMember(
      String memberType,
      String memberUdId,
      String clsId,
      String secId,
      String studentId,
      String stuffId,
      String? createdBy) {
    return baseUrl +
        'api/' +
        'add-library-member?member_type=' +
        memberType +
        '&member_ud_id=' +
        memberUdId +
        '&class=' +
        clsId +
        '&section=' +
        secId +
        '&student=' +
        studentId +
        '&staff=' +
        stuffId +
        '&created_by=$createdBy';
  }

  static String setToken(String? id, String? token) {
    return baseUrl + 'api/' + 'set-fcm-token?id=$id&token=$token';
  }

//APIs to handle push notification requests and services
  static String sentNotificationForAll(int role, String title, String body) {
    return baseUrl +
        'api/' +
        'flutter-group-token?id=$role&body=$body&title=$title';
  }

  static String sentNotificationByToken(String title, String body, String id) {
    return baseUrl +
        'api/' +
        'flutter-notification-api?id=$id&body=$body&title=$title';
  }

  static String sentNotificationToSection(
      String title, String body, String classId) {
    return baseUrl +
        'api/' +
        'homework-notification-api?body=$body&title=$title&class_id=$classId';
  }

  static String sendLeaveData(
      String applyDate,
      String leaveType,
      String leaveForm,
      String leaveTo,
      String? id,
      String reason,
      String path) {
    return baseUrl +
        'api/' +
        'staff-apply-leave?teacher_id=$id&reason=$reason&leave_type=$leaveType&leave_from=$leaveForm&leave_to=$leaveTo&apply_date=$applyDate&attach_file=$path';
  }

  static String setLeaveStatus(int? id, String status) {
    return baseUrl + 'api/' + 'update-leave?id=$id&status=$status';
  }

  static String setAdminLeaveStatus() {
    return baseUrl + 'api/' + 'approve-leave-store';
  }

  static String bookCategory = baseUrl + 'api/' + 'book-category';
  static String subjectList = baseUrl + 'api/' + 'subject';
  static String leaveType = baseUrl + 'api/' + 'staff-leave-type';
  static String applyLeave = baseUrl + 'api/' + 'staff-apply-leave';
  static String getEmail = baseUrl + 'api/' + 'user-demo';
  static String getLibraryMemberCategory =
      baseUrl + 'api/' + 'library-member-role';
  static String getStuffCategory = baseUrl + 'api/' + 'staff-roles';

  static String pendingLeave = baseUrl + 'api/' + 'pending-leave';
  static String approvedLeave = baseUrl + 'api/' + 'approve-leave';
  static String rejectedLeave = baseUrl + 'api/' + 'reject-leave';

  //NEW APIs

  static String getStudentAssignment(int id) {
    return baseUrl + 'api/' + 'studentAssignment/$id';
  }

  static String getStudyMaterial(int id) {
    return baseUrl + 'api/' + 'studentStudyMaterial/$id';
  }

  static String getStudentSyllabus(int id) {
    return baseUrl + 'api/' + 'studentSyllabus/$id';
  }

  static String getStudentOtherDownloads(int id) {
    return baseUrl + 'api/' + 'studentOtherDownloads/$id';
  }

  static String getMyNotifications(int id) {
    return baseUrl + 'api/' + 'myNotification/$id';
  }

  static String readMyNotifications(int userID, notificationID) {
    return baseUrl + 'api/' + 'viewNotification/$userID/$notificationID';
  }

  static String readAllNotification(int userID) {
    return baseUrl + 'api/' + 'viewAllNotification/$userID';
  }

  //these apis donot require authorization token4

  static String getContactInformation(int loginId) {
    return 'get-contact-info/$loginId';
  }

  static String forgotPassword() {
    return baseUrl + 'api/' + 'forgot-password';
  }

  static String recoverPassword() {
    return baseUrl + 'api/' + 'recover-password';
  }

  static String logout() {
    return baseUrl + 'api/' + 'auth/logout';
  }

  static String bankList = baseUrl + 'api/' + 'banks';

  // static String userLeaveType(id) {
  //   return AppConfig.domainName + 'api/' + "my-leave-type/$id";
  // }

  static String allLeaveType() {
    return baseUrl + 'api/' + 'leave-type';
  }

  static String studentUploadHomework =
      baseUrl + 'api/' + 'student-upload-homework';

  static String userApplyLeaveStore =
      baseUrl + 'api/' + 'student-apply-leave-store';

  static String studentApplyLeave(id) {
    return baseUrl + 'api/' + 'student-apply-leave/$id';
  }

  static String approvedLeaves(id) {
    return baseUrl + 'api/' + 'student-approve-leave/$id';
  }

  static String pendingLeaves(id) {
    return baseUrl + 'api/' + 'student-pending-leave/$id';
  }

  static String rejectedLeaves(id) {
    return baseUrl + 'api/' + 'student-reject-leave/$id';
  }

  static String homeworkEvaluationList(classId, sectionId, homeworkId) {
    return baseUrl +
        'api/' +
        'evaluation-homework/$classId/$sectionId/$homeworkId';
  }

  static String evaluateHomework = baseUrl + 'api/' + 'evaluate-homework';

  static String assignVehicle = baseUrl + 'api/' + 'assign-vehicle';

  //Custom Apis are written here
  //parentInfo api
  static String parentInfo(id) {
    return baseUrl + 'api/' + 'parentInfo/$id';
  }

//changed parent api due to some conversion issue
  static Future<ProfileModel> getParentInfo(String? id, String? token) async {
    // Utils().logger.e('id: ' + id + ' token: ' + token);
    http.Response response;
    response = await http.get(Uri.parse(baseUrl + 'api/' + 'parentInfo/$id'),
        headers: Utils.setHeader(token!));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);

      log(decodedData['data']['userDetails'].toString());

      return ProfileModel.fromJson(decodedData);
    } else if (response.statusCode == 404) {
      var decodedData = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg: '404 Error Page not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return ProfileModel.fromJson(decodedData);
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<ProfileModel> getTeacherInfo(int id, String token) async {
    http.Response response;
    response = await http.get(Uri.parse(baseUrl + 'api/' + 'teacherInfo/$id'),
        headers: Utils.setHeader(token));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);

      log(decodedData['data']['userDetails'].toString());

      return ProfileModel.fromJson(decodedData);
    } else if (response.statusCode == 404) {
      var decodedData = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg: '404 Error Page not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return ProfileModel.fromJson(decodedData);
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<ProfileModel> getPrincipalInfo(
      String? id, String? token) async {
    http.Response response;
    response = await http.get(Uri.parse(baseUrl + 'api/' + 'principalInfo/$id'),
        headers: Utils.setHeader(token!));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return ProfileModel.fromJson(decodedData);
    } else if (response.statusCode == 404) {
      var decodedData = jsonDecode(response.body);
      // Utils().logger.e(decodedData);
      Fluttertoast.showToast(
          msg: '404 Error Page not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return ProfileModel.fromJson(decodedData);
    } else {
      throw Exception('Failed to load');
    }
  }

  static String teacherInfo(id) {
    return baseUrl + 'api/' + 'teacherInfo/$id';
  }

  static String principalInfo(id) {
    return baseUrl + 'api/' + 'principalInfo/$id';
  }

  //to get the information of student count in principal dashboard only for principal
  static String principalDashboardMatrix(id) {
    return baseUrl + 'api/' + 'schoolMatrix/$id';
  }

  static String changePassword() {
    return baseUrl + 'api/' + 'changes-password';
  }

  static String schoolMatrices(int? selectedClass, int? selectedSection,
      String? attendanceDate, int userId) {
    return baseUrl +
        'api/' +
        'student-attend-percentage?class=$selectedClass&attendance_date=$attendanceDate&user_id=$userId';
  }

  //Apis for adding. deleting,, editing school notices
  // nput JSON format: {"notice_title":"Test Notice","notice_message":"Test Message...","notice_date":"26-02-2022","publish_on":"28-02-2022","inform_to":"1,2,3,4","academic_id":"5","created_by":"7","is_published";"1"}
  //post request to save notice data in above json format
  static String saveNoticeData() {
    return baseUrl + 'api/' + 'save-notice-data';
  }

  static String editNoticeData() {
    return baseUrl + 'api/' + 'update-notice-data';
  }

  // Method: GET, Request URL: BASE_URL/api/delete-notice/{id}
  static String deleteNoticeData(int? id) {
    return baseUrl + 'api/' + 'delete-notice/$id';
  }

  //Method to delete leave applied
  static String deleteAppliedLeave(int? id) {
    return baseUrl + 'api/' + 'delete-apply-leave/$id';
  }

  static String voucherCode = baseUrl + 'api/' + 'update_passcode';

  static String detail = baseUrl + 'api/' + 'passcode_detail';

  static String VoucherListName(String name) {
    return baseUrl + 'api/' + 'all_passcode?first_name=$name';
  }

  static String VoucherListClassId(int? classId) {
    return baseUrl + 'api/' + 'all_passcode?class_id=$classId';
  }

  static String sendChat = baseApi + 'save-chat-data';
  static String teacherChatlist = baseUrl + 'api/chat-list';
  static String parentChatlist = baseUrl + 'api/learner-chat-list';
  static String getAllStaffCredentials(int? staffId) {
    return baseUrl + 'api/' + 'staff-credential/$staffId';
  }

  static String exportStaffCredentials() {
    return baseUrl + 'api/staff-credential-export';
  }

  static String exportLearners() {
    return baseUrl + 'api/learner-exports';
  }

  static String exportStaffs() {
    return baseUrl + 'api/staff-exports';
  }

  static String exportAttendance(int? classId) {
    return baseUrl + 'api/export-attendance-list?class_id=$classId';
  }

  static String getSchoolGeneralInfo(String schoolId) {
    return 'https://schoolmanagement.co.za/signup/' +
        'api/' +
        'get_school_general_info?school_id=$schoolId';
  }

  static String updateSchoolGeneralInfo() {
    return 'https://schoolmanagement.co.za/signup/' +
        'api/' +
        'update_school_general_info';
  }

  static String getSchoolBackgroundInfo(String schoolId) {
    return 'https://schoolmanagement.co.za/signup/' +
        'api/' +
        'get_school_back_info?school_id=$schoolId';
  }

  static String updateSchoolBackgroundInfo() {
    return 'https://schoolmanagement.co.za/signup/' +
        'api/' +
        'update_school_back_info';
  }

  static String websiteMessages() {
    return baseUrl + 'api/' + 'website-messages';
  }

  static String wallOfFameList() {
    return baseUrl + 'api/' + 'wall-of-fame-list';
  }

  static String wallOfFameAdd() {
    return baseUrl + 'api/' + 'wall-of-fame-add';
  }

  static String wallOfFameUpdate() {
    return baseUrl + 'api/' + 'wall-of-fame-update';
  }

  static String wallOfFameDelete(int id) {
    return baseUrl + 'api/' + 'wall-of-fame-delete/$id';
  }

  static String sponsorOurSchool() {
    return baseUrl + 'api/' + 'school-sponsor-list';
  }

  static String getDistrictEvents() {
    return baseUrl + 'api/' + 'district-event-list';
  }

  static String getSocialFeed() {
    return baseUrl + 'api/' + 'all-feeds';
  }
    static String getSocialFeedCategory() {
    return baseUrl + 'api/' + 'socialcategory-list';
  }
    static String likeSocialFeed() {
    return baseUrl + 'api/' + 'like-dislike-feeds';
  }
   static String newLogin() {
    return baseUrl + 'api/' + 'agentLogin';
  }
}

