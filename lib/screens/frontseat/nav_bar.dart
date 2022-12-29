import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextschool/screens/frontseat/profile_page/profile_screen.dart';
import 'package:nextschool/screens/frontseat/status_page/status_screen.dart';

import '../../utils/Utils.dart';
import 'about_us_screen.dart';
import 'home_page/home_screen.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({Key? key, this.index}) : super(key: key);
  final index;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
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

  int _selectedIndex = 0;
  final _pages = [
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
            iconSize: 30,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.black,
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.clock,
                  ),
                  label: "Status"),
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.person,
                  ),
                  label: "Profile"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.exclamationmark_bubble),
                  label: "About us"),

              // BottomNavigationBarItem(
              //     icon: Icon(Icons.document_scanner), label: "Documents"),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
