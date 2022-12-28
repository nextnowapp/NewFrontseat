import 'package:intl/intl.dart';

class AppMessages {
  AppMessages._();
  static AppMessages? _instance;

  static AppMessages? get instance {
    if (_instance == null) _instance = AppMessages._();
    return _instance;
  }

  // ignore: unnecessary_brace_in_string_interps
  static final _keepAnalysisHappy = Intl.defaultLocale;

  /// `Home`
  String get home => Intl.message(
        'Home',
        name: 'home',
        desc: '',
        args: [],
      );

  /// `Login`
  String get login => Intl.message(
        'Login',
        name: 'login',
        desc: '',
        args: [],
      );

  /// `Register`
  String get register => Intl.message(
        'Register',
        name: 'register',
        desc: '',
        args: [],
      );

  /// `Profile`
  String get profile => Intl.message(
        'Profile',
        name: 'profile',
        desc: '',
        args: [],
      );

  /// `Settings`
  String get settings => Intl.message(
        'Settings',
        name: 'settings',
        desc: '',
        args: [],
      );

  /// `Logout`
  String get logout => Intl.message(
        'Logout',
        name: 'logout',
        desc: '',
        args: [],
      );

  /// `About`
  String get about => Intl.message(
        'About',
        name: 'about',
        desc: '',
        args: [],
      );

  /// `Privacy Policy`
  String get privacyPolicy => Intl.message(
        'Privacy Policy',
        name: 'privacyPolicy',
        desc: '',
        args: [],
      );

  /// `Update Class Time`
  String get updateClassTime => Intl.message(
        'Update Class Time',
        name: 'updateClassTime',
        desc: '',
        args: [],
      );

  /// `Attendance`
  String get attendance => Intl.message(
        'Attendance',
        name: 'attendance',
        desc: '',
        args: [],
      );

  /// `Leave`
  String get leave => Intl.message(
        'Leave',
        name: 'leave',
        desc: '',
        args: [],
      );

  /// `Class Time Table`
  String get classTimeTable => Intl.message(
        'Class Time Table',
        name: 'classTimeTable',
        desc: '',
        args: [],
      );

  /// `Homework`
  String get homework => Intl.message(
        'Homework',
        name: 'homework',
        desc: '',
        args: [],
      );

  /// `Digital Library`
  String get digitalLibrary => Intl.message(
        'Digital Library',
        name: 'digitalLibrary',
        desc: '',
        args: [],
      );

  /// `Subjects`
  String get subjects => Intl.message(
        'Subjects',
        name: 'subjects',
        desc: '',
        args: [],
      );

  /// `Teacher`
  String get teacher => Intl.message(
        'Teacher',
        name: 'teacher',
        desc: '',
        args: [],
      );

  /// `Result`
  String get result => Intl.message(
        'Result',
        name: 'result',
        desc: '',
        args: [],
      );

  /// `School Notice`
  String get schoolNotice => Intl.message(
        'School Notice',
        name: 'schoolNotice',
        desc: '',
        args: [],
      );

  /// `Academic Calendar`
  String get academicCalendar => Intl.message(
        'Academic Calendar',
        name: 'academicCalendar',
        desc: '',
        args: [],
      );

  /// `Digital Content`
  String get digitalContent => Intl.message(
        'Digital Content',
        name: 'digitalContent',
        desc: '',
        args: [],
      );

  /// `School Gen Info`
  String get schoolGenInfo => Intl.message(
        'School Gen Info',
        name: 'schoolGenInfo',
        desc: '',
        args: [],
      );

  /// `Health Questionnaire`
  String get healthQuestionnaire => Intl.message(
        'Health Questionnaire',
        name: 'healthQuestionnaire',
        desc: '',
        args: [],
      );

  /// `Quiz`
  String get quiz => Intl.message(
        'Quiz',
        name: 'quiz',
        desc: '',
        args: [],
      );

  /// `Result & Reports`
  String get resultReports => Intl.message(
        'Result & Reports',
        name: 'resultReports',
        desc: '',
        args: [],
      );

  /// `Online Assessment`
  String get onlineAssessment => Intl.message(
        'Online Assessment',
        name: 'onlineAssessment',
        desc: '',
        args: [],
      );

  /// `Learners`
  String get learners => Intl.message(
        'Learners',
        name: 'learners',
        desc: '',
        args: [],
      );

  /// `Academic`
  String get academic => Intl.message(
        'Academic',
        name: 'academic',
        desc: '',
        args: [],
      );

  /// `Channels`
  String get channels => Intl.message(
        'Channels',
        name: 'channels',
        desc: '',
        args: [],
      );

  /// `Zoom`
  String get zoom => Intl.message(
        'Zoom',
        name: 'zoom',
        desc: '',
        args: [],
      );

  /// `Bulk SMS`
  String get bulkSMS => Intl.message(
        'Bulk SMS',
        name: 'bulkSMS',
        desc: '',
        args: [],
      );

  /// `Assign Learning Area`
  String get assignLearningArea => Intl.message(
        'Assign Learning Area',
        name: 'assignLearningArea',
        desc: '',
        args: [],
      );

  /// `Voucher Search`
  String get voucher => Intl.message(
        'Registration OTP',
        name: 'Registration OTP',
        desc: '',
        args: [],
      );

  //User Approvals
  String get userApprovals => Intl.message(
        'User Approvals',
        name: 'User Approvals',
        desc: '',
        args: [],
      );
}
