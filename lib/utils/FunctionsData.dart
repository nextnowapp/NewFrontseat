// Flutter imports:

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/config/messages.dart';
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/screens/EventsCalendar.dart';
import 'package:nextschool/screens/SettingsScreen.dart';
import 'package:nextschool/screens/academic_calendar.dart';
import 'package:nextschool/screens/admin/Academics/AssignClassTeacher/assign_teacher.dart';
import 'package:nextschool/screens/admin/Academics/AssignClassTeacher/assigned_teacher_list.dart';
import 'package:nextschool/screens/admin/Academics/AssignClassTimeType/add_time_type.dart';
import 'package:nextschool/screens/admin/Academics/AssignClassTimeType/time_type_list.dart';
import 'package:nextschool/screens/admin/Academics/AssignLearningArea/assign_subject_dashboard.dart';
import 'package:nextschool/screens/admin/Academics/AssignLearningArea/assign_subject_screen.dart';
import 'package:nextschool/screens/admin/Academics/AssignLearningArea/assigned_subject_list.dart';
import 'package:nextschool/screens/admin/Academics/ClassRoom/add_class_room.dart';
import 'package:nextschool/screens/admin/Academics/ClassTimeSetup/add_class_time.dart';
import 'package:nextschool/screens/admin/Academics/ClassTimeSetup/class_time_search.dart';
import 'package:nextschool/screens/admin/Academics/Grade/add_grade.dart';
import 'package:nextschool/screens/admin/Academics/Grade/grade_dashboard.dart';
import 'package:nextschool/screens/admin/Academics/Grade/grade_list.dart';
import 'package:nextschool/screens/admin/Academics/LearningAreas/add_learning_area.dart';
import 'package:nextschool/screens/admin/Academics/LearningAreas/learning_area_list.dart';
import 'package:nextschool/screens/admin/Academics/academics_dashboard.dart';
import 'package:nextschool/screens/admin/AdminAttendanceScreen.dart';
import 'package:nextschool/screens/admin/Merits&Demerits/add_remarks.dart';
import 'package:nextschool/screens/admin/Merits&Demerits/merits_n_demerits.dart';
import 'package:nextschool/screens/admin/Merits&Demerits/view_remarks.dart';
import 'package:nextschool/screens/admin/StaffCredentials.dart';
import 'package:nextschool/screens/admin/bulksms/bulk_sms.dart';
import 'package:nextschool/screens/admin/class_wise_timetable.dart';
import 'package:nextschool/screens/admin/leave/AdminLeaveHomeScreen.dart';
import 'package:nextschool/screens/admin/leave/adminLeaveScreen.dart';
import 'package:nextschool/screens/admin/leave/staffLeaveScreen.dart';
import 'package:nextschool/screens/admin/library/AddLibraryBook.dart';
import 'package:nextschool/screens/admin/library/AdminAddMember.dart';
import 'package:nextschool/screens/admin/library/AdminLibraryScreen.dart';
import 'package:nextschool/screens/admin/notice/add_notice.dart';
import 'package:nextschool/screens/admin/notice/notice_dashboard.dart';
import 'package:nextschool/screens/admin/notice/notice_list.dart';
import 'package:nextschool/screens/admin/sponsor_our_school.dart';
import 'package:nextschool/screens/admin/staff/AdminStaffList.dart';
import 'package:nextschool/screens/admin/voucher/detail_voucher.dart';
import 'package:nextschool/screens/admin/website_message_screen.dart';
import 'package:nextschool/screens/attendance_report.dart';
import 'package:nextschool/screens/channels/Circuit_And_District_News/CIrcuit_And_District_News.dart';
import 'package:nextschool/screens/channels/District_events.dart';
import 'package:nextschool/screens/channels/channelHome.dart';
import 'package:nextschool/screens/export_attendance.dart';
import 'package:nextschool/screens/navigation_bar.dart';
import 'package:nextschool/screens/news_feed.dart';
import 'package:nextschool/screens/parent/ChildListScreen.dart';
import 'package:nextschool/screens/parent/Rica.dart';
import 'package:nextschool/screens/parent/chat/ChatListScreen.dart';
import 'package:nextschool/screens/school/our_school_home.dart';
import 'package:nextschool/screens/school/school_background_information.dart';
import 'package:nextschool/screens/school/school_gen_info.dart';
import 'package:nextschool/screens/school/school_management_screen.dart';
import 'package:nextschool/screens/school/wall_of_fame.dart';
import 'package:nextschool/screens/student/Qiuz/comingsoon.dart';
import 'package:nextschool/screens/student/Routine.dart';
import 'package:nextschool/screens/student/StudentAttendance.dart';
import 'package:nextschool/screens/student/StudentTeacher.dart';
import 'package:nextschool/screens/student/SubjectScreen.dart';
import 'package:nextschool/screens/student/TimeLineScreen.dart';
import 'package:nextschool/screens/student/crud/Add%20learners/add_learner.dart';
import 'package:nextschool/screens/student/crud/student_crud_home.dart';
import 'package:nextschool/screens/student/examination/ClassExamResult.dart';
import 'package:nextschool/screens/student/examination/ExaminationScreen.dart';
import 'package:nextschool/screens/student/examination/ScheduleScreen.dart';
import 'package:nextschool/screens/student/homework/StudentHomework.dart';
import 'package:nextschool/screens/student/leave/LeaveListStudent.dart';
import 'package:nextschool/screens/student/leave/LeaveStudentApply.dart';
import 'package:nextschool/screens/student/leave/LeaveStudentHome.dart';
import 'package:nextschool/screens/student/library/BookIssuedScreen.dart';
import 'package:nextschool/screens/student/library/BookListScreen.dart';
import 'package:nextschool/screens/student/library/LibraryScreen.dart';
import 'package:nextschool/screens/student/notice/NoticeScreen.dart';
import 'package:nextschool/screens/student/onlineExam/ActiveOnlineExamScreen.dart';
import 'package:nextschool/screens/student/onlineExam/OnlineExamResultScreen.dart';
import 'package:nextschool/screens/student/onlineExam/OnlineExamScreen.dart';
import 'package:nextschool/screens/student/profile/profile.dart';
import 'package:nextschool/screens/student/studyMaterials/Ebooks.dart';
import 'package:nextschool/screens/student/studyMaterials/StudentAssignment.dart';
import 'package:nextschool/screens/student/studyMaterials/StudentOtherDownloads.dart';
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialList.dart';
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialScreen.dart';
import 'package:nextschool/screens/study_guide/A&APapers.dart';
import 'package:nextschool/screens/study_guide/mind_the_gap.dart';
import 'package:nextschool/screens/teacher/ClassAttendanceHome.dart';
import 'package:nextschool/screens/teacher/TeacherMyAttendance.dart';
import 'package:nextschool/screens/teacher/academic/MySubjectScreen.dart';
import 'package:nextschool/screens/teacher/academic/TeacherRoutineScreen.dart';
import 'package:nextschool/screens/teacher/attendance/AttendanceScreen.dart';
import 'package:nextschool/screens/teacher/chat/SendChat.dart';
import 'package:nextschool/screens/teacher/chat/TeacherChatList.dart';
import 'package:nextschool/screens/teacher/chat/chatHome.dart';
import 'package:nextschool/screens/teacher/content/AddContentScreen.dart';
import 'package:nextschool/screens/teacher/content/ContentListScreen.dart';
import 'package:nextschool/screens/teacher/content/ContentScreen.dart';
import 'package:nextschool/screens/teacher/content/content_list_home.dart';
import 'package:nextschool/screens/teacher/content/staffContentScreen.dart';
import 'package:nextschool/screens/teacher/homework/AddHomeworkScreen.dart';
import 'package:nextschool/screens/teacher/homework/HomeworkScreen.dart';
import 'package:nextschool/screens/teacher/homework/TeacherHomeworkListScreen.dart';
import 'package:nextschool/screens/teacher/leave/ApplyLeaveScreen.dart';
import 'package:nextschool/screens/teacher/leave/LeaveListScreen.dart';
import 'package:nextschool/screens/teacher/leave/LeaveScreen.dart';
import 'package:nextschool/screens/teacher/students/StudentSearch.dart';
import 'package:nextschool/screens/user_approval/approval_list.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/admin/Academics/AssignClassTimeType/class_time_type_dashboard.dart';
import '../screens/admin/Academics/ClassRoom/class_room_list.dart';
import '../screens/admin/Academics/ClassRoom/classroom_dashboard.dart';
import '../screens/admin/Academics/ClassTimeSetup/class_time_setup_dashboard.dart';
import '../screens/admin/Academics/LearningAreas/learning_areas_dashboard.dart';
import '../screens/admin/staff/StaffListScreen.dart';
import '../screens/scientific_calculator/scientificCalculator.dart';

var message = AppMessages.instance;
final Completer<WebViewController> _controller = Completer<WebViewController>();

UserDetailsController _userDetailsController = Get.put(UserDetailsController());

class AppFunction {
  static List<String> students = [
    message!.profile,
    message!.attendance,
    // message!.leave,
    message!.classTimeTable,
    message!.homework,
    message!.digitalLibrary,
    // message!.subjects,
    // message!.teacher,
    'Social Feed',
    message!.result,
    message!.schoolNotice,
    message!.academicCalendar,
    message!.digitalContent,
    // 'Grade 12',

    // message.schoolGenInfo,
    // message.healthQuestionnaire,
    'Merits/Demerits',
    message!.quiz,
    // 'Timeline',
    // 'Result & Reports',
    // 'Online Exam',
    // 'Zoom',
    // 'Settings',
  ];
  static List<String> studentIcons = [
    'assets/svg/student/Student.svg',
    'assets/svg/student/Attendance.svg',
    // 'assets/svg/student/Leave.svg',
    'assets/svg/student/Class Timetable.svg',
    'assets/svg/student/Homework.svg',
    'assets/svg/student/Digital Library.svg',
    // 'assets/svg/student/Subjects.svg',
    // 'assets/svg/student/Teacher.svg',
    'assets/svg/Social Feed.svg',
    'assets/svg/student/Result.svg',
    'assets/svg/teacher/School Notice.svg',
    'assets/svg/student/Academics Calander.svg',
    'assets/svg/student/Digital Content.svg',
    // 'assets/svg/grade12.svg',
    // 'assets/icons/school.png',
    // 'assets/icons/health_questionnaire.png',
    'assets/svg/NSC Papers.svg',
    'assets/svg/student/Quiz.svg',
    // 'assets/images/timeline.png',
    // 'assets/images/onlineexam.png',
    // 'assets/icons/zoom.png',
    // 'assets/images/addhw.png',
  ];

  static List<String> students2 = [
    message!.profile,
    message!.classTimeTable,
    message!.homework,
    message!.digitalContent,
    // 'Timeline',
    message!.attendance,
    message!.academicCalendar,
    message!.result,
    message!.resultReports,
    message!.onlineAssessment,
    // message!.leave,
    message!.schoolNotice,
    message!.subjects,
    message!.teacher,
    message!.digitalLibrary,
    // 'Grade 12',
    // 'Settings',
    'Our School',
    // message!.healthQuestionnaire,
  ];
  static List<String> studentIcons2 = [
    'assets/svg/student/Student.svg',
    'assets/images/routine.png',
    'assets/icons/homework.png',
    'assets/images/downloads.png',
    // 'assets/images/timeline.png',
    'assets/icons/attendance.png',
    'assets/images/calendar.png',
    'assets/images/examination.png',
    'assets/images/onlineexam.png',
    // 'assets/images/leave.png',
    'assets/svg/teacher/School Notice.svg',
    'assets/images/subjects.png',
    'assets/images/teacher.png',
    'assets/icons/library.png',
    // 'assets/svg/grade12.svg',
    // 'assets/images/addhw.png',
    'assets/icons/school.png',
    // 'assets/icons/health_questionnaire.png',
  ];

  static List<String> teachers = [
    message!.learners,

    message!.attendance,
    // message!.leave,
    message!.homework,
    // 'Grade 12',
    'My Timetable',
    'Chat',
    'My Subject',
    message!.schoolNotice,
    message!.digitalLibrary,
    message!.digitalContent,
    'Staff List',
    'Our School',
    message!.academicCalendar,
    message!.academic,
    message!.channels,
    message!.zoom,
    message!.userApprovals,
    // 'Contact',
    // 'Settings',
    // message!.healthQuestionnaire,
    message!.voucher,
    'Social Feed',
    'Scientific Calculator',
    'Merits/Demerits'
  ];

  static List<String> teachersIcons = [
    'assets/svg/teacher/Student.svg',

    'assets/svg/teacher/Attendance.svg',
    // 'assets/svg/teacher/Leave.svg',
    'assets/svg/teacher/Homework.svg',
    // 'assets/images/classroutine.png',
    'assets/svg/Timetable.svg',
    'assets/svg/ChatIcon.svg',
    'assets/svg/student/Subjects.svg',
    'assets/svg/teacher/School Notice.svg',
    'assets/svg/teacher/Digital Library.svg',
    'assets/svg/teacher/Digital Content.svg',
    'assets/svg/Staff List.svg',
    'assets/svg/teacher/School General Info.svg',
    'assets/svg/teacher/Academics Calander.svg',
    'assets/svg/teacher/Academics.svg',
    'assets/svg/teacher/Channels.svg',
    'assets/svg/teacher/Zoom.svg',
    'assets/svg/student/Subjects.svg',
    'assets/svg/Registration OTP.svg',
    'assets/svg/Social Feed.svg',
    'assets/svg/calculator.svg',
    'assets/svg/teacher/Homework.svg',
  ];

  static List<String> teachers2 = [
    message!.learners,
    message!.academic,
    message!.attendance,
    message!.academicCalendar,
    // message!.leave,
    'Digital Contents',
    // 'Grade 12',
    message!.channels,
    'School Notice',
    'Digital Library',
    'Homework',
    // 'Contact',
    // 'Settings',
    'Our School',
    // 'Health Questionnaire',
  ];

  static List<String> teachersIcons2 = [
    'assets/images/students.png',
    'assets/images/academics.png',
    'assets/icons/attendance.png',
    // 'assets/images/leave.png',
    'assets/icons/assignment.png',
    // 'assets/svg/grade12.svg',
    'assets/icons/news.png',
    'assets/icons/school-notice.png',
    'assets/icons/library.png',
    'assets/icons/homework.png',
    // 'assets/images/about.png',
    // 'assets/images/addhw.png',
    'assets/icons/school.png',
    // 'assets/icons/health_questionnaire.png',
  ];
  static List<String> guest = [
    message!.learners,
    message!.attendance,
    // message!.leave,
    message!.homework,
    // 'Grade 12',
    message!.academic,
    message!.schoolNotice,
    message!.digitalLibrary,
    message!.digitalContent,
    'Our School',
    message!.academicCalendar,
    message!.channels,
    // 'Chat',
    message!.zoom,
    // 'Contact',
    // 'Settings',
    // message!.healthQuestionnaire,
  ];

  static List<String> guesticons = [
    'assets/svg/teacher/Student.svg',
    'assets/svg/teacher/Attendance.svg',
    // 'assets/svg/teacher/Leave.svg',
    'assets/svg/teacher/Homework.svg',
    // 'assets/svg/grade12.svg',
    'assets/svg/teacher/Academics.svg',
    'assets/svg/teacher/School Notice.svg',
    'assets/svg/teacher/Digital Library.svg',
    'assets/svg/teacher/Digital Content.svg',
    'assets/svg/teacher/School General Info.svg',

    'assets/svg/teacher/Academics Calander.svg',
    'assets/svg/teacher/Channels.svg',
    'assets/svg/teacher/Zoom.svg',
    // 'assets/images/about.png',
    // 'assets/images/addhw.png',
    // 'assets/svg/teacher/Health Questionnaire.svg',
  ];

  static List<String> admins = [
    message!.learners,
    message!.attendance,
    // 'Attendance Report',
    // message!.leave,
    'Chat',
    'Staff',
    'Homework',
    // 'Grade 12',
    'Digital Library',
    'School Notice',
    'Digital Contents',
    'Our School',
    'Sponsor Our School',
    /* 'Class',
    'Subject',
    'TimeTable',*/
    'Academics',
    // message!.bulkSMS,
    'Website Messages',
    'Staff Credentials',
    'Social Feed',
    message!.academicCalendar,
    message!.channels,
    'Zoom',
    message!.userApprovals,
    message!.voucher,
    'Scientific Calculator',
    'Merits/Demerits'
  ];

  static List<String> adminIcons = [
    'assets/svg/principal/Student.svg',
    'assets/svg/principal/Attendance.svg',
    'assets/svg/ChatIcon.svg',
    // 'assets/svg/principal/Attendance Report.svg',
    // 'assets/svg/principal/Leave.svg',
    'assets/svg/principal/Staffs.svg',
    'assets/svg/principal/Homework.svg',
    // 'assets/svg/grade12.svg',
    'assets/svg/principal/Digital Library.svg',
    'assets/svg/principal/School Notice.svg',
    'assets/svg/principal/Digital Content.svg',
    'assets/svg/principal/School General Info.svg',
    'assets/svg/Sponsors Icon.svg',
    // 'assets/images/classroom.png',
    // 'assets/images/subjects.png',
    // 'assets/images/routine.png',
    'assets/svg/principal/Academics.svg',
    // 'assets/svg/principal/Bulk SMS.svg',
    'assets/svg/Web Messages.svg',
    'assets/svg/Staff Credentials.svg',
    'assets/svg/Social Feed.svg',
    'assets/svg/principal/Academics Calander.svg',
    'assets/svg/principal/Channels.svg',
    'assets/svg/principal/Zoom.svg',
    // 'assets/images/addhw.png',
    // 'assets/icons/school.png',
    'assets/svg/principal/Attendance.svg',
    'assets/svg/Registration OTP.svg',
    // 'assets/images/export.png',
    'assets/svg/calculator.svg',
    'assets/svg/student/Subjects.svg',
    'assets/svg/principal/Export Data.svg',
    'assets/svg/Wellness News.svg'
  ];

  static List<String> admins2 = [
    message!.learners,
    // message!.leave,
    // 'Staff',
    message!.attendance,
    message!.academicCalendar,
    'Digital Contents',
    // 'Grade 12',
    'School Notice',
    message!.channels,
    'Digital Library',
    // 'Settings',
    'Our School',
    // 'Health Questionnaire',
    'Export Data',
  ];

  static List<String> adminIcons2 = [
    'assets/images/students.png',
    // 'assets/images/leave.png',
    // 'assets/images/staff.png',
    'assets/icons/attendance.png',
    'assets/images/leave.png',
    'assets/icons/assignment.png',
    'assets/icons/library.png',
    'assets/icons/school-notice.png',
    'assets/icons/news.png',
    'assets/icons/library.png',
    // 'assets/images/addhw.png',
    'assets/icons/school.png',
    // 'assets/icons/health_questionnaire.png',
    'assets/images/export.png',
  ];

  static List<String> staffCategoryIcons = [
    'assets/svg/Add Staff.svg',
    'assets/svg/Staff List.svg',
    // "assets/images/admin.png",
    // "assets/images/accountant.png",
    // "assets/images/receptionist.png",
    // "assets/images/librarian.png",
    // "assets/images/driver.png",
    // "assets/images/librarian.png",
    // "assets/images/driver.png",
    // "assets/images/parents.png",
  ];

  static List<String> staffCategory = [
    'Add Staff',
    'Staff List',
    // "Admin",
    // "Accountant",
    // "Receptionist",
    // "Librarian",
    // "Driver",
    // "Librarian",
    // "Driver",
    // "Parents",
  ];

  static List<String> studentCrudIcons = [
    'assets/svg/Add Learner.svg',
    'assets/svg/Search Learner.svg',
  ];

  static List<String> studentCrud = [
    'Add Learner',
    'Learner Search',
  ];

  static List<String> parent = [
    'Child',
    // message.attendance,
    'School Notice',
    'Staff List',
    'Events & Calendar',
    'Our School',
    'Chat',
    'Scientific Calculator',
    'RICA',
    // 'Health Questionnaire',
    // 'About',
    // 'Zoom',
    // 'Settings',
  ];
  static List<String> parentIcons = [
    'assets/svg/student/Student.svg',
    // 'assets/icons/attendance.png',
    'assets/svg/student/School Notice.svg',
    'assets/svg/Staff List.svg',
    'assets/svg/student/Events.svg',
    'assets/svg/student/School General Info.svg',
    'assets/svg/ChatIcon.svg',
    'assets/svg/calculator.svg',
    'assets/svg/student/RICA-01.svg',
    // 'assets/svg/student/RICA.svg',
    // 'assets/images/Rica.png',
    // 'assets/svg/student/Health Questionnaire.svg',
  ];

  static List<String> parent2 = [
    'Child',
    // 'About',
    // 'Settings',
  ];

  static List<String> parentIcons2 = [
    'assets/images/mychild.png',
    // 'assets/images/about.png',
    // 'assets/images/addhw.png',
  ];

  static List<String> librarys = [
    'E-books',
    'ANA Papers'
    // 'Books Issued',
  ];
  static List<String> libraryIcons = [
    'assets/svg/E books.svg',
    'assets/svg/ANA Papers.svg'
    // 'assets/svg/Book Issue.svg',
  ];
  static List<String> examinations = [
    'Schedule',
    'Result',
  ];
  static List<String> examinationIcons = [
    'assets/svg/Schedule.svg',
    'assets/svg/Results.svg',
  ];

  static List<String> onlineExaminations = [
    'Active Exam',
    'Exam Result',
  ];
  static List<String> quiz = [
    // 'Start Quiz',
    // 'Quiz Result',
  ];

  static List<String> quizIcon = [
    // 'assets/images/puzzle_piece.png',
    // 'assets/images/results.png',
  ];

  static List<String> onlineExaminationIcons = [
    'assets/svg/Assignments.svg',
    'assets/svg/Results.svg',
  ];

  static List<String> homework = [
    'Add HW',
    'HW List',
  ];
  static List<String> homeworkIcons = [
    'assets/svg/Add Homework.svg',
    'assets/svg/Homework List.svg',
  ];

  static List<String> schoolNotice = [
    'Add Notice',
    'Notice List',
  ];
  static List<String> schoolNoticeIcons = [
    'assets/svg/Add Notice.svg',
    'assets/svg/Notice List.svg',
  ];

  static List<String> zoomMeeting = [
    'Virtual Class',
    'meeting',
  ];
  static List<String> zoomMeetingIcons = [
    'assets/icons/zoom.png',
    'assets/images/hwlist.png',
  ];

  static List<String> contents = [
    'Add Content',
    'Content List',
  ];

  static List<String> contentList = ['Learner Content', 'Staff Content'];

  static List<String> contentListIcons = [
    'assets/svg/Digital Content List.svg',
    'assets/svg/Digital Content List.svg',
  ];

  static List<String> contentsIcons = [
    'assets/svg/Add Digital Content.svg',
    'assets/svg/Digital Content List.svg',
  ];
  static List<String> remarks = [
    'Add Remarks',
    'View Remarks',
  ];

  static List<String> remarkIcons = [
    'assets/svg/Add Digital Content.svg',
    'assets/svg/Digital Content List.svg',
  ];

  static List<String> academicsAdmin = [
    'Class Time',
    // 'Class Room',
    'Class',
    'Learning Areas',
/*    'Optional Learning Area',
    'Assign Learning Area',*/

    'Time Table',
  ];
  static List<String> academicsAdminIcons = [
    'assets/svg/Class Time.svg',
    // 'assets/images/classroom.png',
    'assets/svg/Grade.svg',
    'assets/svg/Learning areas.svg',
/*    'assets/images/subject.png',
    'assets/images/syllabus.png',*/
    // 'assets/images/leave_history.png',
    'assets/svg/Timetable.svg',
  ];

  static List<String> leaves = [
    'Apply Leave',
    'My Leaves',
  ];
  static List<String> leavesIcons = [
    'assets/svg/Apply Leave.svg',
    'assets/svg/My Leaves.svg',
  ];

  static List<String> teacherLeaves = [
    'Apply Leave',
    'My Leaves',
    'Leave Requests',
  ];

  static List<String> teacherLeavesIcons = [
    'assets/svg/Apply Leave.svg',
    'assets/svg/My Leaves.svg',
    'assets/svg/Digital Content List.svg',
  ];

  static List<String> adminLibrary = [
    'E-books',
    'ANA Papers'
    // 'Add Book',
    // 'Add Member',
  ];
  static List<String> adminLibraryIcons = [
    'assets/svg/E books.svg',
    'assets/svg/ANA Papers.svg'
    // 'assets/images/add_content.png',
    // 'assets/images/add_content.png',
  ];

  static List<String> academics = [
    'Class Time Table',
    // 'Class Time Table',
    'Subjects',
  ];
  static List<String> academicsIcons = [
    'assets/svg/Timetable.svg',
    // 'assets/images/classroutine.png',
    'assets/svg/student/Subjects.svg',
  ];

  static List<String> attendance = [
    'Take Attendance',
    'View Attendance',
    'Export Attendance',
  ];

  static List<String> attendanceIcons = [
    'assets/svg/Take attendance.svg',
    'assets/svg/View attendance.svg',
    'assets/svg/Export Attendance.svg',
  ];

  static List<String> assignClass = [
    'Assign Teacher',
    // 'Assigned Teacher',
  ];

  static List<String> assignClassIcons = [
    'assets/svg/Class Teacher.svg',
    // 'assets/svg/Class Teacher.svg',
  ];
  static List<String> assignSubject = [
    message!.assignLearningArea,
    'Assigned Learning Area',
  ];

  static List<String> assignSubjectIcons = [
    'assets/svg/Take attendance.svg',
    'assets/svg/View attendance.svg',
  ];
  // static List<String> Class = [
  //   'Add Class',
  //   'Class List',
  // ];

  static List<String> classIcon = [
    'assets/svg/Class.svg',
    'assets/svg/Class Time.svg',
  ];
  static List<String> grade = [
    'Add Class',
    'Class List',
  ];

  static List<String> gradeIcon = [
    'assets/svg/Grade.svg',
    'assets/svg/Grade.svg',
  ];
  static List<String> classRoom = [
    'Add Class Room',
    'Class Room List',
  ];

  static List<String> classRoomIcon = [
    'assets/svg/Class.svg',
    'assets/svg/Class Time.svg',
  ];
  static List<String> classTime = [
    'Add Class Time',
    'Class Time List',
  ];

  static List<String> classTimeIcon = [
    'assets/svg/Class Time.svg',
    'assets/svg/Search Learner.svg',
  ];
  static List<String> classTimeType = [
    'Add Time Type',
    'Time Type List',
  ];

  static List<String> classTimeTypeIcon = [
    'assets/svg/Take attendance.svg',
    'assets/svg/View attendance.svg',
  ];
  static List<String> learningArea = [
    'Add Learning Area',
    'Learning Area List',
  ];

  static List<String> learningAreaIcon = [
    'assets/svg/Learning areas.svg',
    'assets/svg/Book List.svg',
  ];

  static List<String> parentAttendance = [
    'View Attendance',
  ];
  static List<String> parentAttendanceIcons = [
    'assets/images/search_attendance.png',
  ];

  static List<String> downloadLists = [
    'Assignment',
    'Curriculum',
    'Other Downloads',
    'Study Material'
  ];
  static List<String> downloadListIcons = [
    'assets/svg/Assignments.svg',
    'assets/svg/Curriculum.svg',
    'assets/svg/Other Downloads.svg',
    'assets/svg/Study Materials.svg',
  ];

  static List<String> studentLeaves = [
    'Apply Leave',
    'My Leaves',
  ];

  static List<String> studentLeavesIcons = [
    'assets/images/apply_leave.png',
    'assets/images/leave_history.png',
  ];

  static List<String> adminLeaveScreen = [
    'My Leaves',
    'Apply Leave',
    'Staff Leave',
    'Learner Leave',
  ];

  static List<String> adminLeaveScreenIcons = [
    'assets/icons/my_leave.png',
    'assets/icons/apply_leave.png',
    'assets/icons/person_leave.png',
    'assets/icons/person_leave.png',
  ];

  //added channels here
  static List<String> channels = [
    'Circuit and District News',
    'District Events',
    'School News',
    'Wellness',
  ];

  static List<String> channelsIcons = [
    'assets/svg/Circuit district News.svg',
    'assets/svg/District Events.svg',
    'assets/svg/School News.svg',
    'assets/svg/Wellness News.svg',
  ];
  static List<String> chats = [
    'Send Chat',
    'View Chats',
  ];

  static List<String> chatIcons = [
    'assets/svg/Send to.svg',
    'assets/svg/View chats.svg',
  ];
  static List<String> voucher = [
    'Registration OTP',
  ];

  static List<String> voucherIcons = [
    'assets/svg/Circuit district News.svg',
  ];

  static List<String> ourSchool = [
    'School General Information',
    'School Background Information',
    'School Management Information',
    'School Wall of Fame',
  ];

  static List<String> ourSchoolIcons = [
    'assets/svg/School General Information.svg',
    'assets/svg/School Background Information.svg',
    'assets/svg/School Management Information.svg',
    'assets/svg/Wall of fame.svg',
  ];

  static Widget getFunctions(BuildContext context, String? rule, String? zoom) {
    switch (rule) {
      case '1':
        if (zoom == '1') {
          return CustomNavigationBar(
            titles: admins,
            images: adminIcons,
            rule: rule!,
          );
        } else {
          return CustomNavigationBar(
            titles: admins2,
            images: adminIcons2,
            rule: rule!,
          );
        }
        break;
      case '2':
        if (zoom == '1') {
          return CustomNavigationBar(
            titles: students,
            images: studentIcons,
            rule: rule!,
          );
        } else {
          return CustomNavigationBar(
            titles: students2,
            images: studentIcons2,
            rule: rule!,
          );
        }
        break;
      case '3':
        if (zoom == '1') {
          return CustomNavigationBar(
            titles: parent,
            images: parentIcons,
            rule: rule!,
          );
        } else {
          return CustomNavigationBar(
            titles: parent2,
            images: parentIcons2,
            rule: rule!,
          );
        }
        break;
      case '4':
        if (zoom == '1') {
          return CustomNavigationBar(
            titles: teachers,
            images: teachersIcons,
            rule: rule!,
          );
        } else {
          return CustomNavigationBar(
            titles: teachers2,
            images: teachersIcons2,
            rule: rule!,
          );
        }
        break;
      case '5':
        if (zoom == '1') {
          return CustomNavigationBar(
            titles: admins,
            images: adminIcons,
            rule: rule!,
          );
        } else {
          return CustomNavigationBar(
            titles: admins2,
            images: adminIcons2,
            rule: rule!,
          );
        }
        break;
      case '6':
        if (zoom == null) {
          return CustomNavigationBar(
            titles: guest,
            images: guesticons,
            rule: rule!,
          );
        } else {
          return CustomNavigationBar(
            titles: guest,
            images: guesticons,
            rule: rule!,
          );
        }
        break;
      default:
        return CustomNavigationBar(
          titles: students2,
          images: studentIcons2,
          rule: rule!,
        );
    }
  }

  static Widget? getDashboardPage(BuildContext context, String? title,
      {var id, String? image, int? zoom, String? token}) {
    switch (title) {
      case 'Profile':
        // Navigator.push(
        //     context,
        //     ScaleRoute(
        //         page: ));
        return LearnerProfileScreen(
          id: id,
          image: image,
        );
        break;
      case 'Grade 12':
        return Grade12EBooks();
        break;

      case 'Class Time Table':
        return Routine(id: id);
        break;
      case 'Homework':
        return StudentHomework(id: id);
        break;
      case 'Academic Calendar':
        return const AcademicCalendar();
        break;
      case 'Digital Content':
        return DownloadsHome(downloadLists, downloadListIcons, id: id);
        break;
      case 'Leave':
        return LeaveStudentHome(studentLeaves, studentLeavesIcons, id: id);
        break;
      case 'Subjects':
        return SubjectScreen(
          id: id,
        );
        break;
      case 'Teacher':
        return StudentTeacher(
          id: id,
          token: token,
        );
        break;
      case 'Digital Library':
        return LibraryHome(
          librarys,
          libraryIcons,
          id: id,
        );
        break;

      case 'School Notice':
        return NoticeScreen();
        break;
      case 'Timeline':
        return TimelineScreen(id: id);
        break;
      case 'Result':
      case 'Result & Reports':
        return ExaminationHome(
          examinations,
          examinationIcons,
          id: id,
        );
        break;
      case 'Online Exam':
        return OnlineExaminationHome(
          onlineExaminations,
          onlineExaminationIcons,
          id: id,
        );
        break;
      case 'Social Feed':
        return const NewsFeedScreen(
          admin: false,
        );
      case 'Attendance':
        return StudentAttendanceScreen(id: id, token: token);
        break;
      case 'Our School':
        return OurSchoolHomeScreen(ourSchool, ourSchoolIcons);
        break;
      // case 'Health Questionnaire':
      //   return const HealthQuestionnaire();
      //   break;
      case 'Settings':
        return SettingScreen();
        break;
      case 'Merits/Demerits':
        return ViewRemarks(id: id);
        break;
      case 'Quiz':
        return const ComingSoonScreen();
        break;
      // case 'Registration OTP':
      //   return VoucherHomeScreen(voucher, voucherIcons);
      //   break;
    }
    return null;
  }

  static Widget? getAdminDashboardPage(
      BuildContext context, String title, String? uid) {
    switch (title) {
      case 'Learners':
        return StudentCrudHomeScreen(studentCrud, studentCrudIcons);
        break;
      case 'Grade 12':
        return Grade12EBooks();
        break;
      case 'Bulk SMS':
        return BulkSMSScreen();
        break;
      case 'Academics':
        return AcademicsDashboard(academicsAdmin, academicsAdminIcons);
        break;

      case 'Digital Library':
        return AdminLibraryHome(adminLibrary, adminLibraryIcons);
        break;
      case 'Academic Calendar':
        return const AcademicCalendar();
        break;
      case 'Attendance':
        return AdminAttendanceHomeScreen(attendance, attendanceIcons);
        break;
      case 'Attendance Report':
        return const AttendanceReport();
        break;

      case 'Website Messages':
        return const WebsiteMessagesScreen();

      case 'Staff':
        return AdminStaffList(staffCategory, staffCategoryIcons);
        break;
      case 'Digital Contents':
        return ContentHomeScreen(contents, contentsIcons);
        break;
      case 'Channels':
        return ChannelHome(channels, channelsIcons);
        break;

      case 'Leave':
        return AdminLeaveScreen(adminLeaveScreen, adminLeaveScreenIcons);
        break;
      case 'Settings':
        return SettingScreen();
        break;
      case 'Homework':
        return HomeworkHomeScreen(homework, homeworkIcons);
        break;
        break;
      case 'School Notice':
        return SchoolNoticeHomeScreen(schoolNotice, schoolNoticeIcons);
        break;
      case 'Our School':
        return OurSchoolHomeScreen(ourSchool, ourSchoolIcons);
        break;
      case 'Sponsor Our School':
        return const SponsorOurSchool();
        break;
      // case 'Health Questionnaire':
      //   return const HealthQuestionnaire();
      //   break;
      // case 'Export Data':
      //   return ExportHealthFormData();
      //   break;
      case 'User Approvals':
        return const ApprovalListScreen();
        break;
      case 'Registration OTP':
        return DetailVoucher();
      case 'Merits/Demerits':
        return MeritsNDemerits(remarks, remarkIcons);
      case 'Chat':
        return ChatHome(chats, chatIcons);
      case 'Staff Credentials':
        return const StaffCredentialScreen();
      case 'Scientific Calculator':
        return ScientificCalculator();
      case 'Social Feed':
        return const NewsFeedScreen(
          admin: true,
        );
    }

    return null;
  }

  static Widget? getSaasAdminDashboardPage(
      BuildContext context, String title, String? uid) {
    switch (title) {
      case 'Learners':
        return StudentSearch();
        break;
      case 'Grade 12':
        return Grade12EBooks();
        break;

      case 'Homework':
        return HomeworkHomeScreen(homework, homeworkIcons);
        break;
      case 'Digital Library':
        return AdminLibraryHome(adminLibrary, adminLibraryIcons);
        break;
      case 'Academic Calendar':
        return const AcademicCalendar();
        break;
      case 'Attendance':
        return AdminAttendanceHomeScreen(attendance, attendanceIcons);
        break;
      case 'Digital Contents':
        return ContentHomeScreen(contents, contentsIcons);
        break;
      case 'Channels':
        return ChannelHome(channels, channelsIcons);
        break;

      case 'Staff':
        return AdminStaffList(staffCategory, staffCategoryIcons);
        break;

      case 'School Notice':
        return SchoolNoticeHomeScreen(schoolNotice, schoolNoticeIcons);

        break;
      case 'Leave':
        return LeaveAdminHomeScreen();
        break;
      case 'Settings':
        return SettingScreen();

        break;
      case 'Our School':
        return OurSchoolHomeScreen(ourSchool, ourSchoolIcons);
        break;
      // case 'Health Questionnaire':
      //   return const HealthQuestionnaire();
      //   break;
      // case 'Export Data':
      //   return ExportHealthFormData();
      //   break;
    }
    return null;
  }

  static Widget? getAdminLibraryPage(BuildContext context, String? title) {
    switch (title) {
      case 'E-books':
        return EbookScreen();
        break;
      case 'ANA Papers':
        return ANAPapersScreen();
        break;
      case 'Add Book':
        return AddAdminBook();
        break;
      case 'Add Member':
        return AddMember();
        break;
      case 'Book List':
        return BookListScreen();
        break;
    }
    return null;
  }

  // static void getStaffPage(BuildContext context, String title) {
  //   switch (title) {
  //     case 'Add Staff':
  //       Navigator.push(context, ScaleRoute(page: AddStaffS));
  //       break;
  //     case 'Staff List':
  //       Navigator.push(context, ScaleRoute(page: StaffListScreen()));
  //       break;
  //   }
  // }

  static Widget? getTeacherDashboardPage(
      BuildContext context, String title, String? uid) {
    switch (title) {
      case 'Learners':
        return StudentCrudHomeScreen(studentCrud, studentCrudIcons);
        break;
      case 'Grade 12':
        return Grade12EBooks();
      case 'My Subject':
        return MySubjectScreen();
        break;
      case 'My Timetable':
        return TeacherMyRoutineScreen();
        break;
      // case 'Academic':
      //   return AcademicHomeScreen(academics, academicsIcons);
      //   break;
      case 'Academic':
        return AcademicsDashboard(academicsAdmin, academicsAdminIcons);
        break;
      case 'Attendance':
        return AttendanceHomeScreen(attendance, attendanceIcons);
        break;
      case 'Homework':
        return HomeworkHomeScreen(homework, homeworkIcons);
        break;
      case 'Digital Content':
        return ContentHomeScreen(contents, contentsIcons);
        break;
      case 'Staff List':
        return StaffListScreen(
          null,
          viewOnly: true,
        );
        break;
      case 'Channels':
        return ChannelHome(channels, channelsIcons);
        break;
      case 'Leave':
        return LeaveHomeScreen(teacherLeaves, teacherLeavesIcons);
        break;
      case 'Digital Library':
        return AdminLibraryHome(adminLibrary, adminLibraryIcons);
        break;
      case 'Academic Calendar':
        return const AcademicCalendar();
        break;
      case 'School Notice':
        return SchoolNoticeHomeScreen(schoolNotice, schoolNoticeIcons);
        break;

      case 'Settings':
        return SettingScreen();
        break;

      case 'Our School':
        return OurSchoolHomeScreen(ourSchool, ourSchoolIcons);
        break;
      // case 'Health Questionnaire':
      //   return const HealthQuestionnaire();
      //   break;
      case 'Registration OTP':
        return DetailVoucher();
      case 'User Approvals':
        return const ApprovalListScreen();
      case 'Chat':
        return ChatHome(chats, chatIcons);
      case 'Merits/Demerits':
        return MeritsNDemerits(remarks, remarkIcons);
      case 'Scientific Calculator':
        return ScientificCalculator();
      case 'Social Feed':
        return const NewsFeedScreen(
          admin: false,
        );
    }
    return null;
  }

  static Widget? getVoucherDashboard(BuildContext context, String title) {
    switch (title) {
      case 'Registration OTP':
        return DetailVoucher();
    }
    return null;
  }

  static Widget? getParentDashboardPage(
      BuildContext context, String title, String? uid, String? token) {
    switch (title) {
      case 'School Notice':
        return NoticeScreen();
        break;
      case 'Events & Calendar':
        return EventsCalendar();
        break;
      case 'Grade 12':
        return Grade12EBooks();
        break;
      case 'Attendance':
        return AttendanceHomeScreen(parentAttendance, parentAttendanceIcons);
        break;
      case 'Child':
        return ChildListScreen();
        break;
      case 'Staff List':
        return StaffListScreen(
          null,
          viewOnly: true,
        );
        break;
      case 'Academic Calendar':
        return const AcademicCalendar();
        break;
      case 'Our School':
        return OurSchoolHomeScreen(ourSchool, ourSchoolIcons);
        break;
      case 'Chat':
        return const ChatListScreen();
        break;
      case 'Scientific Calculator':
        return ScientificCalculator();
      case 'RICA':
        return RICA();
        break;
      // case 'About':
      //   Navigator.push(context, ScaleRoute(page: AboutScreen()));
      //   break;
      // case 'Settings':
      //   Navigator.push(context, ScaleRoute(page: SettingScreen()));
      //   break;
      // case 'Zoom':
      //   Navigator.push(
      //       context,
      //       ScaleRoute(
      //           page: VirtualMeetingScreen(
      //         uid: uid,
      //       )));
      //   break;
    }
    return null;
  }

  static Widget? getGuestDashboard(
      BuildContext context, String title, String? uid) {
    switch (title) {
      case 'Learners':
        return null;
        break;
      case 'Grade 12':
        return Grade12EBooks();
        break;
      case 'Academic':
        return null;
        break;
      case 'Attendance':
        return null;
        break;
      case 'Homework':
        return null;
        break;
      case 'Digital Content':
        return null;
        break;
      case 'Channels':
        return null;
        break;
      case 'Leave':
        return null;
        break;
      case 'Digital Library':
        return null;
        break;
      case 'Academic Calendar':
        return null;
        break;
      // case 'Chat':
      //   //TODO: Add chat Screen
      //   // Navigator.push(context, ScaleRoute(page: ChatStudentSearch()));
      //   break;
      case 'School Notice':
        return null;
        break;

      case 'Settings':
        return null;
        break;

      case 'Our School':
        return null;
        break;
      case 'Health Questionnaire':
        return null;
        break;
    }
    return null;
  }

  static Widget? getAttendanceDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Take Attendance':
        return StudentAttendanceHome();
      case 'View Attendance':
        return StudentSearch(
          status: 'attendance',
        );

      case 'My Atten':
        return TeacherAttendanceScreen();
      case 'Export Attendance':
        return const ExportAttendanceScreen();
    }
    return null;
  }

  static Widget? getOurSchoolDashboard(BuildContext context, String? title) {
    switch (title) {
      case 'School General Information':
        return SchoolGenInfoScreen();
        break;
      case 'School Background Information':
        return const SchoolBackgroundInformationScreen();
        break;
      case 'School Management Information':
        return const SchoolManagementScreen();
        break;
      case 'School Wall of Fame':
        return const SchoolWallOfFame();
        break;
    }
    return null;
  }

  static Widget? getAdminAttendanceDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      // case 'Class Atten':
      case 'Take Attendance':
        return StudentAttendanceHome();
      // case 'Search Atten':
      case 'View Attendance':
        return StudentSearch(
          status: 'attendance',
        );
      case 'Export Attendance':
        return const ExportAttendanceScreen();
    }
    return null;
  }

  static Widget? getAcademicDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'Subjects':
        return MySubjectScreen();
        break;
      // case 'Class Time Table':
      //   Navigator.push(context, ScaleRoute(page: SearchRoutineScreen()));
      //   break;
      // case 'My Class Routine':
      //   Navigator.push(context, ScaleRoute(page: TeacherMyRoutineScreen()));
      //   break;
      case 'Class Time Table':
        return TeacherMyRoutineScreen();
        break;
    }
    return null;
  }

  static Widget? getLibraryDashboardPage(BuildContext context, String? title,
      {var id}) {
    switch (title) {
      case 'E-books':
        return EbookScreen();
        break;
      case 'ANA Papers':
        return ANAPapersScreen();
        break;

      case 'Books Issued':
        return BookIssuedScreen(
          id: id,
        );
        break;
    }
    return null;
  }

  static Widget? getQuizDashboardPage(BuildContext context, String? title,
      {var id}) {
    switch (title) {
      case 'Start Quiz':
        // Navigator.push(context, ScaleRoute(page: QuizScreen()));
        break;
      case 'Quiz Result':
        // Navigator.push(context, ScaleRoute(page: ScoreScreen()));
        break;
    }
    return null;
  }

  static Widget? getHomeworkDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'HW List':
        return TeacherHomework();
        break;
      case 'Add HW':
        return AddHomeworkScrren();
        break;
    }
    return null;
  }

  static Widget? getAdminLeaveDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'My Leaves':
        return LeaveListScreen();
        break;
      case 'Staff Leave':
        return StaffLeaveHomeScreen();
        break;
      case 'Learner Leave':
        return LeaveAdminHomeScreen();
        break;
      case 'Apply Leave':
        return ApplyLeaveScreen();
        break;
    }
    return null;
  }

  static Widget? getAssignClassTeacherDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Assign Teacher':
        return const AssignClassTeacherScreen();
        break;
      // case 'Assigned Teacher':
      //   return const AssignedClassTeacherScreen();
      //   break;
    }
    return null;
  }

  static Widget? getClassRoomDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Add Class Room':
        return AddClassRoom(
          isEdit: false,
        );
        break;
      case 'Class Room List':
        return const ClassRoomList();
        break;
    }
    return null;
  }

  static Widget? getClassTimeSetupDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Add Class Time':
        return AddClassTime(isEdit: false);
        break;
      case 'Class Time List':
        return ClassTimeSearch();
        break;
    }
    return null;
  }

  static Widget? getClassTimeTypeDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Add Time Type':
        return const AddClassTimeType();
        break;
      case 'Time Type List':
        return const ClassTimeTypeList();
        break;
    }
    return null;
  }

  // static Widget? getClassDashboardPage(BuildContext context, String? title) {
  //   switch (title) {
  //     case 'Add Class':
  //       return AddClass(
  //         isEdit: false,
  //       );
  //       break;
  //     case 'Class List':
  //       return const ClassList();
  //       break;
  //   }
  //   return null;
  // }

  static Widget? getLearningAreasDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Add Learning Area':
        return AddLearningArea(
          isEdit: false,
        );
        break;
      case 'Learning Area List':
        return const LearningAreaList();
        break;
    }
    return null;
  }

  static Widget? getGradeDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'Add Class':
        return AddGrade(
          isEdit: false,
        );
        break;
      case 'Class List':
        return const GradeList();
        break;
    }
    return null;
  }

  static Widget? getAcademicsDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Class Time':
        return ClassTimeSetupDashboard(classTime, classTimeIcon);
        break;
      case 'Class Room':
        return ClassRoomDashboard(classRoom, classRoomIcon);
        break;
      // case 'Class':
      //   return ClassDashboard(Class, classIcon);
      //   break;
      case 'Assign Learning Area':
        return AssignSubjectDashboard(assignSubject, assignSubjectIcons);
        break;
      case 'Class':
        return GradeDashboard(grade, gradeIcon);
        break;
      case 'Optional Learning Area':
        return const AssignedClassTeacherScreen();
        break;
      case 'Learning Areas':
        return LearningAreasDashboard(learningArea, learningAreaIcon);
        break;
      case 'Class Time Type':
        return ClassTimeTypeDashboard(classTimeType, classTimeIcon);
        break;
      case 'Time Table':
        return ClassWiseTimeTable();
        break;
    }
    return null;
  }

  static Widget? getAssignSubjectTeacherDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Assign Learning Area':
        return const AssignSubjectScreen();
        break;
      case 'Assigned Learning Area':
        return const AssignedSubjectScreen();
        break;
    }
    return null;
  }

  static Widget? getNoticeDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'Add Notice':
        return const AddNoticeScreen();
        break;
      case 'Notice List':
        return const NoticeListScreen();
        break;
    }
    return null;
  }

  static Widget? getChannelsDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'Circuit and District News':
        return const CircuitAndDistrictNewsListScreen();
      case 'District Events':
        return const DistrictEventsScreen();
      // case 'School News':
      //   return const SchoolNewsListScreen();
      //   break;
    }
    return null;
  }

  static Widget? getChatDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'Send Chat':
        return const SendChatScreen();

      case 'View Chats':
        return const TeacherChatListScreen();
    }
    return null;
  }

  static Widget? getContentDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'Content List':
        return ContentListHome(contentList, contentListIcons);
        break;
      case 'Add Content':
        return AddContentScreeen();
        break;
    }
    return null;
  }

  static Widget? getContentListHome(BuildContext context, String? title) {
    switch (title) {
      case 'Learner Content':
        return ContentListScreen();
        break;
      case 'Staff Content':
        return StaffContentScreen();
        break;
    }
    return null;
  }

  static Widget? getMeritNDemeritDashboard(
      BuildContext context, String? title) {
    switch (title) {
      case 'Add Remarks':
        return const AddRemarksScreen();
        break;
      case 'View Remarks':
        return StudentSearch(
          status: 'remark',
        );
        break;
    }
    return null;
  }

  // static Widget? getVoucherDashboard(BuildContext context, String title) {
  //   switch (title) {
  //     case 'Registration OTP':
  //       return VoucherSearch();
  //       break;
  //   }
  //   return null;
  // }

  static Widget? getLearnerCrudDashboardPage(
      BuildContext context, String? title) {
    switch (title) {
      case 'Add Learner':
        // return AddLearnerScreen(isEdit: false);
        return const AddLearner();
        break;
      case 'Learner Search':
        return StudentSearch();
        break;
    }
    return null;
  }

  static Widget? getLeaveDashboardPage(BuildContext context, String? title) {
    switch (title) {
      case 'My Leaves':
        return LeaveListScreen();
        break;
      case 'Apply Leave':
        return ApplyLeaveScreen();
        break;
      case 'Leave Requests':
        return LeaveAdminHomeScreen();
        break;
    }
    return null;
  }

  static Widget? getExaminationDashboardPage(
      BuildContext context, String? title,
      {var id}) {
    switch (title) {
      case 'Schedule':
        return ScheduleScreen(
          id: id,
        );
        break;
      case 'Result':
        return ClassExamResultScreen(
          id: id,
        );
        break;
    }
    return null;
  }

  static Widget? getDownloadsDashboardPage(BuildContext context, String? title,
      {var id}) {
    switch (title) {
      case 'Assignment':
        return StudentAssignment(
          id: id,
        );
        break;
      // case 'Curriculum':
      //   return StudentSyllabus(
      //     id: id,
      //   );
      //   break;
      case 'Other Downloads':
        return StudentOtherDownloads(
          id: id,
        );
        break;

      case 'Study Material':
        return StudyMaterialList(
          id: id,
        );
        break;
    }
    return null;
  }

  static Widget? getStudentLeaveDashboardPage(
      BuildContext context, String? title,
      {var id}) {
    switch (title) {
      case 'Apply Leave':
        return LeaveStudentApply(id);
        break;
      case 'My Leaves':
        return LeaveListStudent(
          id: id,
        );
        break;
    }
    return null;
  }

  static Widget? getOnlineExaminationDashboardPage(
      BuildContext context, String? title,
      {var id}) {
    switch (title) {
      case 'Active Exam':
        return ActiveOnlineExamScreen(
          id: id,
        );
        break;
      case 'Exam Result':
        return OnlineExamResultScreen(
          id: id,
        );
        break;
    }
    return null;
  }

  static String getContentType(String ctype) {
    String type = '';
    switch (ctype) {
      case 'as':
        type = 'assignment';
        break;
      case 'st':
        type = 'study material';
        break;
      case 'sy':
        type = 'curriculum';
        break;
      case 'ot':
        type = 'others download';
        break;
    }
    return type;
  }

  static List<String> weeks = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  //formet time
  static String getAmPm(String time) {
    var parts = time.split(':');
    String part1 = parts[0];
    String part2 = parts[1];

    int hr = int.parse(part1);
    int min = int.parse(part2);

    if (hr <= 12) {
      if (hr == 10 || hr == 11 || hr == 12) {
        return '$hr:$min' + 'AM';
      }
      return '0$hr:$min' + 'AM';
    } else {
      hr = hr - 12;
      return '0$hr:$min' + 'PM';
    }
  }

  static String getExtention(String url) {
    var parts = url.split('/');
    return parts[parts.length - 1];
  }

  //return day of month
  static String getDay(String date) {
    var parts = date.split('-');
    return parts[parts.length - 1];
  }
}
// _launchURL(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
