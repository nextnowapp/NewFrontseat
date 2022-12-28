// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';

import 'AdminLeavePager.dart';

class StaffLeaveHomeScreen extends StatefulWidget {
  @override
  _StaffLeaveHomeScreenState createState() => _StaffLeaveHomeScreenState();
}

class _StaffLeaveHomeScreenState extends State<StaffLeaveHomeScreen>
    with SingleTickerProviderStateMixin {
  int bottomSelectedIndex = 0;
  var _id;
  TabController? _tabController;

  @override
  void initState() {
    Utils.getStringValue('id').then((value) {
      _id = value;
    });
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  static List<Tab> _tabs = <Tab>[
    Tab(
      text: 'Pending'.toUpperCase(),
    ),
    Tab(
      text: 'Approved'.toUpperCase(),
    ),
    Tab(
      text: 'Denied'.toUpperCase(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: ' Staff Leave',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF222744),
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // isScrollable: true,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: const Color(0xFF4E88FF),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                tabs: _tabs,
              ),
            ),
          ),
          Expanded(
            child: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: DefaultTabController(
                length: _tabs.length,
                initialIndex: 0,
                child: Builder(
                  builder: (context) {
                    final TabController tabController =
                        DefaultTabController.of(context)!;
                    tabController.addListener(() {
                      if (tabController.indexIsChanging) {
                        print(tabController.index);
                      }
                    });
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Column(
                        children: [
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                AdminLeavePage(InfixApi.staffPendingLeave(),
                                    'pending_request',
                                    isStaff: true),
                                AdminLeavePage(InfixApi.staffApprovedLeave(),
                                    'approve_request',
                                    isStaff: true),
                                AdminLeavePage(
                                  InfixApi.staffRejectedLeave(),
                                  'rejected_request',
                                  isStaff: true,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // buildPageView(),
        ],
      ),
    );
  }
}
