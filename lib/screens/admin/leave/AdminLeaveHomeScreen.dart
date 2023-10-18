// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';

import 'AdminLeavePager.dart';

class LeaveAdminHomeScreen extends StatefulWidget {
  @override
  _LeaveAdminHomeScreenState createState() => _LeaveAdminHomeScreenState();
}

class _LeaveAdminHomeScreenState extends State<LeaveAdminHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
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
        title: 'Learners Leave',
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
                        DefaultTabController.of(context);
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
                                AdminLeavePage(
                                    InfixApi.pendingLeave, 'pending_request',
                                    isStaff: false),
                                AdminLeavePage(
                                    InfixApi.approvedLeave, 'approve_request',
                                    isStaff: false),
                                AdminLeavePage(
                                    InfixApi.rejectedLeave, 'rejected_request',
                                    isStaff: false)
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
