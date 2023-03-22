import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/controller/kyc_step_model.dart';
import 'package:nextschool/screens/frontseat/profile_page/profile_screen.dart';
import 'package:nextschool/screens/frontseat/status_page/status_screen.dart';
import 'package:sizer/sizer.dart';

import '../../utils/Utils.dart';
import 'about_us_screen.dart';
import 'document_page/training_documents.dart';
import 'home_page/home_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key, this.index}) : super(key: key);
  final index;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final kycStepModelController = Get.put(KycStepModel());

  var id;
  @override
  void initState() {
    Utils.getIntValue('id').then((value) {
      setState(() {
        id = value;
      });
    });
    if (widget.index != null) {
      _selectedIndex = widget.index;
    } else {
      _selectedIndex = 0;
    }
  }

  List<BottomNavigationBarItem> activeItems = [
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.home,
        ),
        label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.clock,
        ),
        label: 'Status'),
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.person,
        ),
        label: 'Profile'),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.exclamationmark_bubble), label: 'About us'),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.exclamationmark_bubble), label: 'Documents'),
  ];
  List<BottomNavigationBarItem> inActiveItems = [
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.home,
        ),
        label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.clock,
        ),
        label: 'Status'),
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.person,
        ),
        label: 'Profile'),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.exclamationmark_bubble), label: 'About us'),
  ];
  int _selectedIndex = 0;
  final _activePages = [
    const HomeScreen(),
    const CustomSidebar(),
    const ProfileScreen(),
    const AboutUs(),
    EbookScreen()
  ];
  final _inActivePages = [
    const HomeScreen(),
    const CustomSidebar(),
    const ProfileScreen(),
    const AboutUs(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            iconSize: 26,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle:
                TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w600),
            selectedLabelStyle:
                TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
            currentIndex: _selectedIndex,
            items: kycStepModelController.activeValue
                ? activeItems
                : inActiveItems,
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.document_scanner), label: "Documents"),

            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
        body: kycStepModelController.activeValue
            ? _activePages[_selectedIndex]
            : _inActivePages[_selectedIndex],
      ),
    );
  }
}
