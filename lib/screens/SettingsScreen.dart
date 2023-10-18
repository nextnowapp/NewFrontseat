// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<bool> isSelected = [false, false];
  GlobalKey _scaffold = GlobalKey();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  var _token;
  @override
  void initState() {
    super.initState();
    print('Splash Screen Initiated');
    _token = _userDetailsController.token;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF222744),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: CustomAppBarWidget(title: 'Settings'),
          backgroundColor: Colors.white,
          key: _scaffold,
          body: ListView(
            children: <Widget>[
              InkWell(
                onTap: () {
                  showAlertDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(16),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ListTile(
              //   title: Text(
              //     'Logout',
              //     style: TextStyle(
              //         color: Color(0xFF222744),
              //         fontSize: ScreenUtil().setSp(16),
              //         fontWeight: FontWeight.w500),
              //   ),
              //   trailing: Icon(
              //     Icons.logout,
              //     color: Color(0xFF222744),
              //     size: ScreenUtil().setSp(20),
              //   ),
              //   onTap: () {
              //     showAlertDialog(context);
              //   },
              // ),
            ],
          ),
        ));
  }

  showAlertDialog(BuildContext context) async {
    Widget cancelButton = TextButton(
      child: Text(
        'No',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontSize: ScreenUtil().setSp(14), color: Colors.white),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF4E88FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Center(
        child: Text(
          'Yes',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: ScreenUtil().setSp(14),
                color: Colors.white,
              ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () async {
        if (_userDetailsController.isLogged) {
          Utils.clearAllValue();
          Navigator.of(context, rootNavigator: true).pop();
          await saveBooleanValue('hideOnboardingScreen', true);
          Route route =
              MaterialPageRoute(builder: (context) => const LandingScreen());
          Navigator.pushAndRemoveUntil(
              context, route, ModalRoute.withName('/'));
        } else {
          Utils.clearAllValue();
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.pop();
          await saveBooleanValue('hideOnboardingScreen', true);
          Route route =
              MaterialPageRoute(builder: (context) => const LandingScreen());
          // Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));

          var response = await http.post(Uri.parse(InfixApi.logout()),
              headers: Utils.setHeader(_token.toString()));
          Navigator.pushAndRemoveUntil(
              context, route, ModalRoute.withName('/'));
        }
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: const Color(0xFF222744),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Are you sure, you want to logout?',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: yesButton,
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: cancelButton,
                ),
              ],
            )
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  void rebuildAllChildren(BuildContext context) {
//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (BuildContext context) {
//      return MyApp();
    Route route = MaterialPageRoute(
        builder: (context) => const MyApp(
              zoom: null,
              rule: null,
              homeWidget: null,
              isLogged: false,
            ));
    Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));
  }
}
