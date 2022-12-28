import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:nextschool/screens/choose_school.dart';
import 'package:nextschool/screens/landing_screen.dart';
import 'package:nextschool/utils/model/OnboardingScreenItems.dart';
import 'package:nextschool/utils/widget/back_button.dart';
import 'package:nextschool/utils/widget/next_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int? _page;
  final PageController _pageController = PageController();

  late Animation animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    _page = 0;
    //getting language code from memory and using this code we fetch translated data from asset/locale
  }

  @override
  void dispose() {
    _pageController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              // physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: onboardingScreenItems.length,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      bottom: ScreenUtil()
                          .setHeight(MediaQuery.of(context).size.height * 0.25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Lottie.asset(
                            onboardingScreenItems.elementAt(index).image,
                            frameRate: FrameRate(60),
                            animate: true,
                            repeat: true,
                            width: (_page == onboardingScreenItems.length - 4)
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.9,
                            height: (_page == onboardingScreenItems.length)
                                ? MediaQuery.of(context).size.height * 0.40
                                : MediaQuery.of(context).size.height * 0.50,
                            fit: BoxFit.fitWidth,
                            controller: controller,
                            onLoaded: (composition) {
                              controller
                                ..duration = composition.duration
                                ..forward();
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.06,
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 40.0, right: 40.0, top: 20.0),
                        child: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: ((onboardingScreenItems
                                              .elementAt(index)
                                              .title
                                              .replaceFirst('Now.', ''))
                                          .replaceFirst('Now', ''))
                                      .replaceFirst(
                                          'a mobile-first generation', ''),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: onboardingScreenItems
                                          .elementAt(index)
                                          .title
                                          .contains('Now')
                                      ? 'Now.'
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF4e87fe),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(
                                  MediaQuery.of(context).size.height * 0.01),
                            ),
                            onboardingScreenItems
                                    .elementAt(index)
                                    .title
                                    .contains('a mobile-first generation')
                                ? Container(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF4e87fe),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Text(
                                      '\n    a mobile first generation    \n',
                                      style: TextStyle(
                                        color: Colors.white,
                                        height: 0.7,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Positioned(
                      bottom: ScreenUtil()
                          .setHeight(MediaQuery.of(context).size.height * 0.1),
                      left: 50,
                      right: 50,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50.0,
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: (((onboardingScreenItems
                                              .elementAt(index)
                                              .content
                                              .replaceFirst('online.', ''))
                                          .replaceFirst('digital age.', ''))
                                      .replaceFirst('9:00 AM.', '')),
                                  style: const TextStyle(
                                      // color: Color(0xFF4e87fe),
                                      color: Colors.black,
                                      fontSize: 20,
                                      height: 1.2),
                                ),
                                TextSpan(
                                  text: onboardingScreenItems
                                          .elementAt(index)
                                          .content
                                          .contains('online.')
                                      ? 'online.'
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF4e87fe),
                                  ),
                                ),
                                TextSpan(
                                  text: onboardingScreenItems
                                          .elementAt(index)
                                          .content
                                          .contains('9:00 AM.')
                                      ? '9:00 AM.'
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF4e87fe),
                                  ),
                                ),
                                TextSpan(
                                  text: onboardingScreenItems
                                          .elementAt(index)
                                          .content
                                          .contains('digital age')
                                      ? 'digital age.'
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF4e87fe),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          // (_page == onboardingScreenItems.length - 1)
                          // ? Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       RichText(
                          //         textAlign: TextAlign.center,
                          //         softWrap: true,
                          //         text: TextSpan(
                          //           style: const TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 12,
                          //               height: 1.4),
                          //           children: [
                          //             const TextSpan(
                          //                 text:
                          //                     'By continuing you are agree to NextSchool\'s '),
                          //             TextSpan(
                          //               text: 'T&C',
                          //               style: const TextStyle(
                          //                 color: Colors.blue,
                          //                 decoration:
                          //                     TextDecoration.underline,
                          //               ),
                          //               recognizer: TapGestureRecognizer()
                          //                 ..onTap = () => launchUrl(Uri.parse(
                          //                     'http://schoolmanagement.co.za/TnC')),
                          //             ),
                          //             const TextSpan(text: ' and '),
                          //             TextSpan(
                          //               text: 'Privacy Policy.',
                          //               recognizer: TapGestureRecognizer()
                          //                 ..onTap = () => launchUrl(Uri.parse(
                          //                     'http://schoolmanagement.co.za/privacy')),
                          //               style: const TextStyle(
                          //                 color: Colors.blue,
                          //                 decoration:
                          //                     TextDecoration.underline,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       RichText(
                          //         softWrap: true,
                          //         textAlign: TextAlign.center,
                          //         text: TextSpan(
                          //           recognizer: TapGestureRecognizer()
                          //             ..onTap = () => launchUrl(Uri.parse(
                          //                 'http://schoolmanagement.co.za/popia')),
                          //           style: const TextStyle(
                          //               color: Colors.black, fontSize: 12),
                          //           children: [
                          //             const TextSpan(
                          //                 text:
                          //                     'You agree and consent to POPIA.'),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   )
                          // : Container(),
                        ],
                      ),
                    ),
                  ],
                );
              },
              onPageChanged: (value) {
                setState(() {
                  _page = value;
                  controller.reset();
                  controller.forward();
                });
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 32,
            right: 29,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: _page == 0 ? false : true,
                        child: InkWell(
                            onTap: () {
                              _pageController.previousPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.decelerate);
                            },
                            child: const BackBtn())),
                    Visibility(
                        visible: _page == (onboardingScreenItems.length)
                            ? false
                            : true,
                        child: InkWell(
                            onTap: () async {
                              if (_page == onboardingScreenItems.length - 1) {
                                await saveBooleanValue(
                                    'hideOnboardingScreen', true);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LandingScreen()));
                              } else {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.decelerate);
                              }
                            },
                            child: const NextButton())),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(
                        onboardingScreenItems.length,
                        (index) => Container(
                          height: (_page == index) ? 2 : 2,
                          width: (_page == index) ? 14 : 14,
                          decoration: BoxDecoration(
                            color: (_page == index) ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }
}
