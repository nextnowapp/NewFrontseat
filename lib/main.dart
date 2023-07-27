// Flutter imports:
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextschool/config/app_config.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/frontseat/agent_login/controller/login_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/agent_contract/controller/contract_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_bank_details/controller/upload_bank_details_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_govt_id/controller/upload_govt_id_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_personal_information/controller/upload_personal_information_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_selfie/controller/upload_selfie_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_signature/controller/signature_bloc.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';
import 'package:nextschool/screens/frontseat/nav_bar.dart';
import 'package:nextschool/screens/frontseat/services/kyc_api.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  bool hideOnboarding = false;
  Widget? widget;

  //Getx controllers defined
  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());

  // //gradelist controller
  // GradeListController gradeListController = Get.put(GradeListController());

  // //subject list controller
  // SubjectListController subjectListController =
  //     Get.put(SubjectListController());

  // //attendance stat controller
  // AttendanceStatController attendanceStatController =
  //     Get.put(AttendanceStatController());

  //Notification controller
  // NotificationController notificationController =
  //     Get.put(NotificationController());
//starting the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
    AppConfig.appVersion = packageInfo.version;
  });
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Utils.packageInfo = await PackageInfo.fromPlatform();

  HttpOverrides.global = new MyHttpoverrides();
  // await precachePicture(
  //     ExactAssetPicture(
  //         SvgPicture.svgStringDecoderBuilder, 'assets/images/doodle_bg.svg'),
  //     null);

  bool isLogged = await Utils.getBooleanValue('isLogged');
  userDetailsController.isLogged = isLogged;

  if (isLogged) {
    // read values from local storage
    var id = await Utils.getIntValue('id');
    var roleId = await Utils.getIntValue('roleId');
    var role = await Utils.getStringValue('rule');
    var fullname = await Utils.getStringValue('fullname');
    var mobile = await Utils.getStringValue('mobile');
    var genderId = await Utils.getIntValue('genderId');
    var zoom = await Utils.getIntValue('zoom');
    var isAdministrator = await Utils.getStringValue('isAdministrator');
    var token = await Utils.getStringValue('token');
    await KycApi.AgentStatus();
    await KycApi.kycStatus();

    //set values to controller
    userDetailsController.id = id;
    userDetailsController.roleId = roleId;
    userDetailsController.role = role;
    userDetailsController.fullName = fullname;
    userDetailsController.mobile = mobile;
    userDetailsController.genderId = genderId;
    userDetailsController.zoom = zoom;
    userDetailsController.is_administrator = isAdministrator;
    userDetailsController.token = token;
    userDetailsController.isLogged = isLogged;

    //apis calls using controllers
    // notificationController.fetchUnreadNotificationCount();
    // if (userDetailsController.roleId != 3) {
    //   gradeListController.fetchGradeList();
    //   subjectListController.fetchSubjectList();
    //   subjectListController.fetchSubjectList();
    //   attendanceStatController.fetchAttendanceStat();
    // }
  } else {
    widget = const LandingScreen();
  }

  //make errorbox transparent
  RenderErrorBox.backgroundColor = Colors.transparent;

  //custom error box
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Something went wrong!',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('error').add({
                'error': details.toString(),
                'time': DateTime.now(),
              }).then(
                (value) => Utils.showErrorToast(
                    'Error details sent to developer. We will fix it soon.'),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  };

  runApp(MyApp(
    isLogged: isLogged,
    homeWidget: widget,
    rule: userDetailsController.roleId.toString(),
    zoom: userDetailsController.zoom.toString(),
  ));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatefulWidget {
  final bool isLogged;
  final String? rule;
  final String? zoom;
  final Widget? homeWidget;

  const MyApp(
      {Key? key,
      required this.isLogged,
      required this.rule,
      required this.zoom,
      required this.homeWidget})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool? isRTL;
  bool isOffline = false;
  late StreamSubscription subscription;
  bool hasInternet = true;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    startChecking();
  }

  Future<void> startChecking() async {
    final result = await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result);
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    setState(() {
      hasInternet = result != ConnectivityResult.none;
    });
    final message = hasInternet
        ? 'You have again ${result.toString()}'
        : 'You have no internet';
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => UploadSelfieBloc()),
        BlocProvider(create: (context) => UploadPersonalInformationBloc()),
        BlocProvider(create: (context) => UploadGovtIdBloc()),
        BlocProvider(create: (context) => UploadBankDetailsBloc()),
        BlocProvider(
          create: (context) => ContractBloc(),
        ),
        BlocProvider(
          create: (context) => SignatureBloc(),
        )
      ],
      child: ScreenUtilInit(
        splitScreenMode: true,
        builder: (context, child) => GetMaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              themeMode: ThemeMode.light,
              builder: (context, child) {
                return MediaQuery(
                  child: child!,
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                );
              },
              title: 'Frontseat',
              navigatorKey: _navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: basicTheme(),
              home: widget.isLogged ? const BottomBar() : widget.homeWidget,
            );
          }),
        ),
      ),
    );
  }
}
