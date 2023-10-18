// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/teacher/content/ContentDetailsScreen.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
// Project imports:
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Content.dart';
import 'package:nextschool/utils/widget/Content_row.dart';
import 'package:nextschool/utils/widget/textwidget.dart';

import '../../../utils/widget/404ErrorWidget.dart';
import '../../../utils/widget/customLoader.dart';

class StaffContentScreen extends StatefulWidget {
  @override
  _StaffContentScreenState createState() => _StaffContentScreenState();
}

class _StaffContentScreenState extends State<StaffContentScreen>
    with SingleTickerProviderStateMixin {
  Future<ContentList?>? contents;
  late TabController _tabController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  String? _token;
  String? _id;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    contents = fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Content List',
        ),
        body: Column(
          children: [
            TabBar(
              splashFactory: InkRipple.splashFactory,
              splashBorderRadius: BorderRadius.circular(30.0),
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              controller: _tabController,
              tabs: <Widget>[
                const Tab(text: 'Study Materials'),
                const Tab(text: 'Class Assignments'),
                const Tab(text: 'Other Downloads'),
              ],
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                FutureBuilder<ContentList?>(
                  future: contents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.contents.length == 0) {
                        return const Center(
                            child:
                                // Utils.noDataImageWidget() //TODO
                                TextWidget(txt: 'No data'));
                      } else
                        return ListView.builder(
                            itemCount: snapshot.data!.contents.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data!.contents[index].type! ==
                                  'Study Material') {
                                return ContentCard(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContentDetailsScreen(
                                                content: snapshot
                                                    .data!.contents[index],
                                              )),
                                    );
                                  },
                                  date: snapshot
                                      .data!.contents[index].uploadDate!,
                                  title: snapshot.data!.contents[index].title!,
                                  description: snapshot
                                      .data!.contents[index].description!,
                                );
                              } else {
                                return const SizedBox();
                              }
                            });
                    } else if (snapshot.hasError) {
                      return const widget_error_404();
                    } else {
                      return const Center(
                        child: CustomLoader(),
                      );
                    }
                  },
                ),
                //Assignments
                FutureBuilder<ContentList?>(
                  future: contents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      log(snapshot.data!.toString());
                      if (snapshot.data!.contents.length == 0) {
                        return const Center(
                            child:
                                // Utils.noDataImageWidget() //TODO
                                TextWidget(txt: 'No data'));
                      } else
                        return ListView.builder(
                            itemCount: snapshot.data!.contents.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data!.contents[index].type! ==
                                  'Assignment') {
                                return ContentCard(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContentDetailsScreen(
                                                content: snapshot
                                                    .data!.contents[index],
                                              )),
                                    );
                                  },
                                  date: snapshot
                                      .data!.contents[index].uploadDate!,
                                  title: snapshot.data!.contents[index].title!,
                                  description: snapshot
                                      .data!.contents[index].description!,
                                );
                              } else {
                                return const SizedBox();
                              }
                            });
                    } else if (snapshot.hasError) {
                      return const widget_error_404();
                    } else {
                      return const Center(
                        child: CustomLoader(),
                      );
                    }
                  },
                ),
                // Other Downloads
                FutureBuilder<ContentList?>(
                  future: contents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.contents.length == 0) {
                        return const Center(
                            child:
                                // Utils.noDataImageWidget() //TODO
                                TextWidget(txt: 'No data'));
                      } else
                        return ListView.builder(
                            itemCount: snapshot.data!.contents.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data!.contents[index].type! ==
                                  'Other Download') {
                                return ContentCard(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContentDetailsScreen(
                                                content: snapshot
                                                    .data!.contents[index],
                                              )),
                                    );
                                  },
                                  date: snapshot
                                      .data!.contents[index].uploadDate!,
                                  title: snapshot.data!.contents[index].title!,
                                  description: snapshot
                                      .data!.contents[index].description!,
                                );
                              } else {
                                return const SizedBox();
                              }
                            });
                    } else if (snapshot.hasError) {
                      return const widget_error_404();
                    } else {
                      return const Center(
                        child: CustomLoader(),
                      );
                    }
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void _removeItem(int index, List<Content> cList) {
    int removeIndex = index;
    Content removeItem = cList.removeAt(removeIndex);
    AnimatedRemovedItemBuilder builder = (context, animation) {
      return ContentRow(removeItem, animation, index: index);
    };
    _listKey.currentState!.removeItem(removeIndex, builder);
  }

  Future<ContentList?>? fetchContent() async {
    final response = await http
        .get(Uri.parse(InfixApi.getStaffContent()),
            headers: Utils.setHeader(_token!))
        .catchError((e) {
      var msg = e.response.data['message'];
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var contentList =
          ContentList.fromJson(jsonData['data']['uploadContents']);
      return contentList;
    } else {
      throw Exception('failed to load');
    }
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final String description;
  final String date;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                      size: 20,
                    ),
                    TextWidget(
                      txt: date,
                      clr: Colors.grey,
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Image.asset('assets/images/pdf.png'),
                title: Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextWidget(
                    txt: title,
                    size: 20,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextWidget(txt: description),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
