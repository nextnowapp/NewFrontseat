import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/agent_active_screen.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/agent_contract/contract_screen.dart';
import 'package:nextschool/screens/frontseat/agent_register/new_register_screen.dart';
import 'package:nextschool/screens/frontseat/home_page/widgets/action_card.dart';
import 'package:nextschool/screens/frontseat/home_page/widgets/contract_card.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';
import 'package:nextschool/screens/frontseat/model/banner_model.dart';
import 'package:nextschool/screens/frontseat/model/thoughts_model.dart';
import 'package:nextschool/screens/frontseat/services/api_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../../../utils/model/ReceivedSms.dart';
import '../../../utils/widget/textwidget.dart';
import '../agent_onboarding/form_resubmission_page.dart';
import '../agent_onboarding/submitted_for_verification.dart';
import '../agent_onboarding/upload_signature/signature_screen.dart';
import '../agent_onboarding/verify_account.dart';
import '../ammendment/ammendment_screen.dart';
import '../services/kyc_api.dart';
import '../termination/termination_screen.dart';
import '../widgets/custom_appbar.dart';

//notificatiopn handler
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final CarouselController _controller = CarouselController();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  String? notificationToken;
  final kycStepModelController = Get.put(KycStepModel());
  var id;
  String? deviceToken;
  String? bigAdsBanner;
  String? smallAdsBanner;
  int count = 0;
  BannerModel? bannerList;
  int _current = 0;
  ThoughtsModel? thoughts;
  Thought? thought;

  Future fetchBannerDetails() async {
    // https://schoolmanagement.co.za/signup/api/campaign-search
    //use dio for post request
    var dio = Dio();
    var data = FormData.fromMap({
      'school_id': 'LPVWDZCPWH07',
      'role_id': _userDetailsController.roleId,
      'age': 1,
      'gender': 1
    });
    var response = await dio.post(
      'https://manager.improovajobs.co.za/api/banner-search',
      data: data,
    );
    log(response.data.toString() + 'banner');
    if (response.statusCode == 200) {
      setState(() {
        bannerList = BannerModel.fromJson(response.data);
      });
    } else if (response.statusCode == 401) {
      // Utils.invalidAuthenticationRedirection(Get.context!);
    }
    return bigAdsBanner;
  }

  String getKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Future fetchCampaignDetails() async {
    DateTime now = DateTime.now();
    count = await Utils.getIntValue(getKey(now)) ?? 0;
    count++;
    Utils.saveIntValue(getKey(now), count);
    // https://schoolmanagement.co.za/signup/api/campaign-search
    //use dio for post request

    var dio = Dio();
    var data = FormData.fromMap({
      'school_id': 'LPVWDZCPWH07',
      'role_id': _userDetailsController.roleId,
      'age': 1,
      'gender': 1
    });

    var response = await dio.post(
      'https://manager.improovajobs.co.za/api/campaign-search',
      data: data,
    );
    log(response.data.toString() + 'Campaign');

    if (response.statusCode == 200) {
      setState(() {
        bigAdsBanner = response.data['data']['big_banner_image_url'];
        smallAdsBanner = response.data['data']['small_banner_image_url'];
      });
    } else if (response.statusCode == 401) {
      // Utils.invalidAuthenticationRedirection(Get.context!);
    }
    return bigAdsBanner;
  }

  void showHelloWorld() {
    log('Banner shown in my_class_home.dart');
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: FutureBuilder(
                        future: fetchCampaignDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(imageUrl: bigAdsBanner!);
                          } else
                            return Container();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 13,
                  height: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Icon(CupertinoIcons.clear_thick_circled,
                        color: Colors.black87, size: 30),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    Utils.getIntValue(getKey(DateTime.now())).then((value) {
      if (value == null || value < 200) {
        showHelloWorld();
      }
    });
    fetchBannerDetails();

    KycApi.kycStatus();
    KycApi.AgentStatus();
    getThoughts();
    //init settings for android
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload));
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //     onSelectNotification: (String? payload) async {
      //   if (payload != null) {
      //     debugPrint('notification payload: ' + payload);
      //   }
      //   selectNotificationSubject.add(payload);
      // }
    );

    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {},
            )
          ],
        ),
      );
    });

    selectNotificationSubject.stream.listen((String? payload) async {});
    this.notificationSubscription();
  }

  notificationSubscription() async {
    print('token get');
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    messaging.getToken().then((value) {
      setState(() {
        deviceToken = value;
        sendTokenToServer(deviceToken);
        print('Notify TOKEN Got: $deviceToken');
      });
    });
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final receivedSms = receivedSmsFromJson(message.data['message']);

      if (receivedSms.phoneNumber == null) {
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
          if (mounted) {}

          RemoteNotification notification = message.notification!;

          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      }
    });

    //push to NotificationListScreen when user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        if (mounted) {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewRegisterScreen()),
            );
          } catch (e) {
            print(e.toString());
          }
        }
      }
    });

    Future<void> _firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      //route to NotificationListScreen when user taps on notification
      print('Handling a background message: ${message.messageId}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        if (mounted) {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewRegisterScreen(),
              ),
            );
          } catch (e) {
            print(e.toString());
          }
        }
      }
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomAppbar(
          title: 'Frontseat',
        ),
        Expanded(
          child: ListView(
            children: [
              Wrap(
                children: [
                  bannerList != null && bannerList!.data!.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            CarouselSlider(
                              items: List.generate(
                                  bannerList!.data!.length,
                                  (index) => InkWell(
                                        onTap: () {
                                          launchUrl(Uri.parse(bannerList!
                                                  .data![index].bannerSiteUrl ??
                                              ''));
                                        },
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          width: 100.w,
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                              color: HexColor('#f8f8f8'),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      bannerList!.data![index]
                                                              .bannerimageurl ??
                                                          ''),
                                                  fit: BoxFit.contain)),
                                        ),
                                      )),
                              carouselController: _controller,
                              options: CarouselOptions(
                                  autoPlayInterval: const Duration(seconds: 3),
                                  viewportFraction: 0.75,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  aspectRatio: 2.0,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeFactor: 0.3,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: bannerList!.data!
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () =>
                                      _controller.animateToPage(entry.key),
                                  child: Container(
                                    width: 7.0,
                                    height: 7.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(_current == entry.key
                                                ? 0.9
                                                : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      : const SizedBox(),

                  // ActionCards(
                  //     title: 'My Work',
                  //     ontap: () async {
                  //       Navigator.pushNamed(context, AppRoutes.verifyEmailScreen);
                  //     },
                  //     titleBg: Colors.white,
                  //     asset: 'assets/images/myTasks.png',
                  //     bgColor: Colors.blue),
                  ActionCards(
                    titleBg: kycStepModelController.inContractingValue ||
                            kycStepModelController.contractedValue
                        ? Colors.black
                        : Colors.white,
                    bgColor: kycStepModelController.inContractingValue ||
                            kycStepModelController.contractedValue
                        ? const Color(0xfff7b7b7)
                        : const Color(0xff76b17b),
                    title: kycStepModelController.pdfReadyValue
                        ? 'View Contract'
                        : kycStepModelController.inContractingValue ||
                                kycStepModelController.contractedValue
                            ? 'Signing Contract\ndocument by Agent'
                            : 'Agent\nOnboarding',
                    asset: kycStepModelController.inContractingValue ||
                            kycStepModelController.contractedValue
                        ? 'assets/images/Signing contract.png'
                        : 'assets/images/Mask1.png',
                    ontap: () async {
                      if (kycStepModelController.activeValue) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const AgentActiveScreen(),
                          ),
                        );
                      } else if (kycStepModelController.pdfReadyValue) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const ContractScreen(),
                          ),
                        );
                      } else if (kycStepModelController
                              .allStepsCompletedValue &&
                          kycStepModelController.inContractingValue &&
                          kycStepModelController.contractedValue) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                const SubmittedForVerificationScreen(),
                          ),
                        );
                      } else if (kycStepModelController
                              .allStepsCompletedValue &&
                          kycStepModelController.inContractingValue) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SignatureScreen(),
                          ),
                        );
                      } else if (kycStepModelController.isEditableValue) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                const FormReSubmissionScreen(),
                          ),
                        );
                      } else if (kycStepModelController
                          .allStepsCompletedValue) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                const SubmittedForVerificationScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const VerificationScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  ContractCards(
                    bgColor: kycStepModelController.inContractingValue ||
                            kycStepModelController.contractedValue
                        ? const Color(0Xffe4f2fd)
                        : const Color(0xfffbe48a),
                    title: 'Request Amendments',
                    ontap: () async {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const AmmendementScreen()));
                    },
                  ),

                  ContractCards(
                    bgColor: kycStepModelController.inContractingValue ||
                            kycStepModelController.contractedValue
                        ? const Color(0xfff2dde2)
                        : const Color(0xffff907d),
                    title: 'Request Termination',
                    ontap: () async {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const TerminationScreen()));
                    },
                  )
                ],
              ),
              TextButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'Are you sure you want to sign out?',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        actionsPadding: const EdgeInsets.only(right: 8),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              // perform sign out logic here
                              kycStepModelController.allStepsCompletedValue =
                                  false;
                              kycStepModelController.bankDetailsValue = false;
                              kycStepModelController.govtIdUploadedValue =
                                  false;
                              kycStepModelController
                                  .personalInformationUpdatedValue = false;
                              kycStepModelController.selfieUpdatedValue = false;
                              kycStepModelController.isEditableValue = false;
                              kycStepModelController.inContractingValue = false;
                              kycStepModelController.contractedValue = false;
                              kycStepModelController.activeValue = false;
                              kycStepModelController.pdfReadyValue = false;
                              kycStepModelController.reviewerValue = '';
                              kycStepModelController.commentValue = '';
                              await Utils.clearAllValue();
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const LandingScreen()));
                            },
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: TextWidget(
                          txt: 'Sign Out',
                          size: 18,
                          clr: Colors.white,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        thought != null
            ? Center(
                child: Container(
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Column(
                            children: [
                              Text(
                                '\"${thought!.thought ?? ''}\"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: HexColor('#A9A9A9'),
                                    fontFamily:
                                        GoogleFonts.badScript().fontFamily,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(
                                '- ${thought!.author ?? ''}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: HexColor('#A9A9A9'),
                                    fontFamily: GoogleFonts.inter().fontFamily),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  void sendTokenToServer(devicetoken) async {
    var _token = await Utils.getStringValue('token');
    var _id = await Utils.getIntValue('id');
    log(deviceToken ?? 'hey');
    Dio dio = Dio();
    dio.options.headers = Utils.setHeader(_token!);
    var response = await dio
        .get(
      FrontSeatApi.setToken(_id.toString(), devicetoken),
    )
        .catchError((e) {
      switch (e.response.statusCode) {
        case 400:
          Utils.showToast('${e.response.data['message']}');
          break;
        case 401:
          Utils.showToast('${e.response.data['message']}');

          break;
        case 403:
          Utils.showToast('${e.response.data['message']}');

          break;
        case 404:
          Utils.showToast('${e.response.data['message']}');

          break;
        case 500:
          Utils.showToast('${e.response.data['message']}');

          break;
        default:
          Utils.showToast('${e.response.data['message']}');
      }
    });

    print(response.data);
    if (response.statusCode == 200) {
      print(response.data.toString());
      print('token updated : $deviceToken');
    } else {
      throw Exception('Failed to load');
    }
  }

  getThoughts() async {
    //check if the data is already in the cache
    //key : thought_list

    try {
      final response = await http.get(
          Uri.parse('https://manager.improovajobs.co.za/api/thought_list'),
          headers: Utils.setHeader(_userDetailsController.token.toString()));

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        setState(() {
          thoughts = ThoughtsModel.fromJson(decoded);
          int today = DateTime.now().day % thoughts!.data!.length;
          thought = thoughts!.data![today];
        });
      }
    } catch (e) {
      log('error fetching');

      Utils.showErrorToast(e.toString());
    }
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [],
      ),
    );
  }
}
