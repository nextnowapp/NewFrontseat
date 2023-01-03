import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/agent_contract/contract_screen.dart';
import 'package:nextschool/screens/frontseat/home_page/widgets/action_card.dart';
import 'package:nextschool/screens/frontseat/home_page/widgets/contract_card.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../../../utils/widget/textwidget.dart';
import '../agent_onboarding/form_resubmission_page.dart';
import '../agent_onboarding/submitted_for_verification.dart';
import '../agent_onboarding/verify_account.dart';
import '../ammendment/ammendment_screen.dart';
import '../termination/termination_screen.dart';
import '../widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  String? notificationToken;
  final kycStepModelController = Get.put(KycStepModel());
  var id;
  @override
  void initState() {
    super.initState();
    Utils.getIntValue('id').then((value) {
      id = value;
      // KycApi.kycStatus(id);
      // KycApi.AgentStatus(id);
    });
  }

  //   var initializationSettingsAndroid =
  //       const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initializationSettingsIOS = IOSInitializationSettings(
  //       onDidReceiveLocalNotification:
  //           (int id, String? title, String? body, String? payload) async {
  //     didReceiveLocalNotificationSubject.add(ReceivedNotification(
  //         id: id, title: title, body: body, payload: payload));
  //   });
  //   var initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: (String? payload) async {
  //     if (payload != null) {
  //       debugPrint('notification payload: $payload');
  //     }
  //     selectNotificationSubject.add(payload);
  //   });
  //   didReceiveLocalNotificationSubject.stream
  //       .listen((ReceivedNotification receivedNotification) async {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: receivedNotification.title != null
  //             ? Text(receivedNotification.title!)
  //             : null,
  //         content: receivedNotification.body != null
  //             ? Text(receivedNotification.body!)
  //             : null,
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: const Text('Ok'),
  //             onPressed: () async {},
  //           )
  //         ],
  //       ),
  //     );
  //   });
  //   notificationSubscription() async {
  //     NotificationSettings settings = await messaging.requestPermission(
  //       alert: true,
  //       announcement: false,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true,
  //     );
  //     notificationToken = await Utils.getStringValue('deviceToken');
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       var receivedSms;
  //       if (message.notification != null) {
  //         print(
  //             'Message also contained a notification: ${message.notification!.title}');
  //         RemoteNotification notification = message.notification!;

  //         flutterLocalNotificationsPlugin.show(
  //             notification.hashCode,
  //             notification.title,
  //             notification.body,
  //             NotificationDetails(
  //               android: AndroidNotificationDetails(
  //                 channel.id,
  //                 channel.name,
  //                 channelDescription: channel.description,
  //                 icon: '@mipmap/ic_launcher',
  //               ),
  //             ));
  //       }
  //     });

  //     FirebaseMessaging.onMessageOpenedApp.listen(
  //       (RemoteMessage message) {
  //         print('Got a message whilst in the onMessageOpenedApp!');
  //         print('Notification Title : ${message.notification!.title}');
  //         print('Notification Body: ${message.notification!.body}');
  //         print('DATA: ${message.data.toString()}');
  //         if (message.notification != null) {
  //           print(
  //               'Message also contained a notification: ${message.notification}');
  //         }
  //       },
  //     );
  //   }

  //   selectNotificationSubject.stream.listen((String? payload) async {});
  //   notificationSubscription();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomAppbar(
          title: "Frontseat",
        ),
        Expanded(
          child: ListView(
            children: [
              Wrap(
                children: [
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
                    title: kycStepModelController.inContractingValue ||
                            kycStepModelController.contractedValue
                        ? 'Signing Contract\ndocument by Agent'
                        : 'Agent\nOnboarding',
                    asset: kycStepModelController.inContractingValue ||
                            kycStepModelController.contractedValue
                        ? "assets/images/Signing contract.png"
                        : "assets/images/Mask1.png",
                    ontap: () async {
                      if (kycStepModelController.allStepsCompletedValue &&
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
                            builder: (context) => ContractScreen(),
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
                  kycStepModelController.inContractingValue ||
                          kycStepModelController.contractedValue
                      ? ContractCards(
                          bgColor: const Color(0Xffe4f2fd),
                          title: 'Request Ammendments',
                          ontap: () async {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const AmmendementScreen()));
                          },
                        )
                      : ActionCards(
                          titleBg: Colors.black,
                          bgColor: const Color(0xfffbe48a),
                          asset: "assets/images/Mask2.png",
                          ontap: () async {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const AmmendementScreen()));
                          },
                          title: 'Request\nAmmendments',
                        ),
                  kycStepModelController.inContractingValue ||
                          kycStepModelController.contractedValue
                      ? ContractCards(
                          bgColor: const Color(0xfff2dde2),
                          title: 'Request Termination',
                          ontap: () async {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const TerminationScreen()));
                          },
                        )
                      : ActionCards(
                          titleBg: Colors.white,
                          asset: "assets/images/Mask3.png",
                          bgColor: const Color(0xffff907d),
                          ontap: () async {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const TerminationScreen()));
                          },
                          title: 'Request\nTermination',
                        ),
                ],
              ),
              TextButton(
                onPressed: () async {
                  kycStepModelController.allStepsCompletedValue = false;
                  kycStepModelController.bankDetailsValue = false;
                  kycStepModelController.govtIdUploadedValue = false;
                  kycStepModelController.personalInformationUpdatedValue =
                      false;
                  kycStepModelController.selfieUpdatedValue = false;
                  kycStepModelController.isEditableValue = false;
                  kycStepModelController.inContractingValue = false;
                  kycStepModelController.contractedValue = false;
                  kycStepModelController.commentValue = "";
                  await Utils.clearAllValue();
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const LandingScreen()));
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
      ],
    );
  }
}
