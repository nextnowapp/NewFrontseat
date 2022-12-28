import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/main.dart';
import 'package:nextschool/screens/add_event_screen.dart';
import 'package:nextschool/screens/choose_school.dart';
import 'package:nextschool/screens/landing_screen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/event_model.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/user_controller.dart';
import '../utils/widget/ShimmerListWidget.dart';

class Calendar extends StatefulWidget {
  final bool? preventAppBar;

  Calendar({Key? key, this.preventAppBar, this.rule}) : super(key: key);
  String? rule;
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF222744),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: null, //AppBarWidget(title: 'Events & Calendar'),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _userDetailsController.roleId == 1 ||
                        _userDetailsController.roleId == 5
                    ? Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEventScreen(
                                        token: _token,
                                      )),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.blue,
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 0.8,
                                  ),
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/student/Events.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Utils.sizedBoxWidth(10),
                                const TextWidget(
                                  txt: 'Add Event',
                                  weight: FontWeight.w500,
                                  clr: Colors.white,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Utils.sizedBoxHeight(10),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  availableGestures: AvailableGestures.all,
                  availableCalendarFormats: const {
                    CalendarFormat.month: '',
                    CalendarFormat.week: '',
                  },
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                      outsideDaysVisible: true,
                      canMarkersOverflow: true,
                      isTodayHighlighted: true,
                      selectedDecoration: ShapeDecoration.fromBoxDecoration(
                          BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all())),
                      todayTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Colors.black)),
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        color: Color(0xff4E88FF),
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                    formatButtonVisible: false,
                    leftChevronVisible: true,
                    rightChevronVisible: true,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Color(0xff4E88FF)),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Color(0xff4E88FF)),
                  ),
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Colors.red),
                      weekdayStyle: TextStyle(color: Color(0xff4E88FF))),
                  onDaySelected: (date, events) {
                    print(date.toUtc());
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(300.0)),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                    todayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xff4E88FF),
                            borderRadius: BorderRadius.circular(300.0)),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                Utils.sizedBoxHeight(20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: SvgPicture.asset(
                        'assets/svg/student/Events.svg',
                        width: 15,
                        height: 15,
                      ),
                    ),
                    Utils.sizedBoxWidth(6),
                    const TextWidget(
                      txt: 'Upcoming Events',
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<EventModel?>(
                      future: getEventList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.data!.length == 0) {
                            return Utils.noDataTextWidget();
                          } else
                            return ListView.builder(
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) {
                                //convert string date (dd/mm/yyyy) to DateTime
                                var date = snapshot.data!.data![index].fromDate;
                                //convert to yyyy-mm-dd
                                var dd = date!.split('/')[0];
                                var mm = date.split('/')[1];
                                var yyyy = date.split('/')[2];
                                date = yyyy + '-' + mm + '-' + dd;

                                var dateParse = DateTime.parse(date);
                                var difference =
                                    dateParse.difference(DateTime.now()).inDays;

                                if (difference < 0) {
                                  return const SizedBox();
                                } else
                                  return Container(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    width: double.infinity,
                                    // height: 75,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                              TextWidget(
                                                txt:
                                                    '${snapshot.data!.data![index].fromDate!} to ${snapshot.data!.data![index].toDate!}',
                                                weight: FontWeight.w500,
                                                clr: Colors.black54,
                                              ),
                                              Utils.sizedBoxWidth(50),
                                              Expanded(
                                                child: TextWidget(
                                                  txt: snapshot
                                                      .data!
                                                      .data![index]
                                                      .eventLocation!,
                                                  weight: FontWeight.w500,
                                                  clr: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Utils.sizedBoxHeight(10),
                                          TextWidget(
                                            txt: snapshot
                                                .data!.data![index].eventTitle!,
                                            weight: FontWeight.w500,
                                            size: 16,
                                          ),
                                          Utils.sizedBoxHeight(10),
                                          TextWidget(
                                            txt: snapshot
                                                .data!.data![index].eventDes!,
                                            size: 16,
                                          ),
                                          Utils.sizedBoxHeight(10),
                                          //icon to update and delete
                                          Visibility(
                                            visible: _userDetailsController
                                                        .roleId ==
                                                    1 ||
                                                _userDetailsController.roleId ==
                                                    5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddEventScreen(
                                                          token: _token,
                                                          isEdit: true,
                                                          data: snapshot.data!
                                                              .data![index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                Utils.sizedBoxWidth(20),
                                                InkWell(
                                                  onTap: () {
                                                    showDeleteAlertDialog(
                                                      context,
                                                      snapshot.data!
                                                          .data![index].id!,
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                              },
                            );
                        } else {
                          return ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return ShimmerList(
                                itemCount: 1,
                                height: 80,
                              );
                            },
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ));
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  String parsetime(DateTime date) {
    String formattedDate = DateFormat('h:mm a').format(date);
    return formattedDate;
  }

  Future<EventModel> getEventList() async {
    debugPrint('call');

    final response = await http.get(Uri.parse(InfixApi.getEvents()),
        headers: Utils.setHeader(_token.toString()));

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = EventModel.fromJson(jsonData);
      print(jsonData);
      // print(data.data);
      return data;
    } else {
      throw Exception('Failed to load');
    }
  }

  showDeleteAlertDialog(BuildContext context, int id) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DeleteBottomSheet(
          onDelete: () async {
            Utils.showProcessingToast();
            setState(() {
              deleteEvent(id);
            });
          },
          title: 'Delete this event',
        );
      },
    );
  }

  Future<void> deleteEvent(int id) async {
    Navigator.pop(context);

    final response = await http.get(Uri.parse(InfixApi.deleteEvent(id)),
        headers: Utils.setHeader(_token!));
    if (response.statusCode == 200) {
      var msg = jsonDecode(response.body)['message'];
      Utils.showToast(msg);
    } else {
      var msg = jsonDecode(response.body)['message'];
      Utils.showToast(msg);
      throw Exception('failed to load');
    }
  }
}

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  AppBarWidget({this.title});

  String? title;

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  int i = 0;
  Future? notificationCount;

  int? rtlValue;
  String? _email;
  String? _password;
  String? _rule;
  String? _id;
  String? schoolId;
  String? isAdministrator;
  String? _token;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  void navigateToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        'Cancel',
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.red,
            ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        'Yes',
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.green,
            ),
      ),
      onPressed: () async {
        Utils.clearAllValue();
        Navigator.pop(context);
        Route route = MaterialPageRoute(
            builder: (context) => const MyApp(
                  zoom: null,
                  homeWidget: null,
                  isLogged: false,
                  rule: null,
                ));

        Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));

        var response = await http.post(Uri.parse(InfixApi.logout()),
            headers: Utils.setHeader(_token.toString()));
        // if (response.statusCode == 200) {
        // } else {
        //   Utils.showToast('Unable to logout');
        // }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Logout',
        style: Theme.of(context).textTheme.headline5,
      ),
      content: const Text('Would you like to logout?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: Column(
          children: [
            AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage(AppConfig.appToolbarBackground),
                  //   fit: BoxFit.fill,
                  // ),
                  color: Color(0xFF222744),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 70.h,
                        width: 70.w,
                        child: IconButton(
                            tooltip: 'Back',
                            icon: Icon(
                              Icons.arrow_back,
                              size: ScreenUtil().setSp(20),
                            ),
                            onPressed: () {
                              navigateToPreviousPage(context);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text(
                          widget.title!,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontSize: ScreenUtil().setSp(20),
                                  color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 10.0),
                    //   child: FutureBuilder(
                    //     future: Utils.getStringValue('email'),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<String> snapshot) {
                    //       return getProfileImage(
                    //           context, _email, _password, _rule);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            Visibility(
              visible: _userDetailsController.isLogged,
              child: Container(
                child: Column(
                  children: [
                    const Text(
                      'You are not logged in. Please login to continue.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[50]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            'assets/icons/arrow-right.svg',
                            color: Colors.black,
                            height: ScreenUtil().setHeight(12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
