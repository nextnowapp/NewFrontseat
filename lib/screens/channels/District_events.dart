import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/DistrictEventModel.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controller/user_controller.dart';
import '../../utils/Utils.dart';
import '../../utils/apis/Apis.dart';

class DistrictEventsScreen extends StatefulWidget {
  const DistrictEventsScreen({Key? key}) : super(key: key);

  @override
  State<DistrictEventsScreen> createState() => _DistrictEventsScreenState();
}

class _DistrictEventsScreenState extends State<DistrictEventsScreen> {
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  Future<Events?>? events;
  List _colors = ['#ffefda', '#ffdaeb', '#dafff8', '#d9e4fe'];
  var data = {
    {
      's_time': '7:00 am',
      'e_time': '7:00 am',
      'title': 'Party time',
      'desc': 'party tonight at tagore hall of the school',
      'loc': 'london',
      'date': '12/12/2022'
    },
    {
      's_time': '7:00 am',
      'e_time': '7:00 am',
      'title': 'Party time',
      'desc': 'party tonight at tagore hall of the school',
      'loc': 'london',
      'date': '12/12/2022'
    },
    {
      's_time': '7:00 am',
      'e_time': '7:00 am',
      'title': 'Party time',
      'desc': 'party tonight at tagore hall of the school',
      'loc': 'london',
      'date': '11/12/2022'
    },
    {
      's_time': '7:00 am',
      'e_time': '7:00 am',
      'title': 'Party time',
      'desc': 'party tonight at tagore hall of the school',
      'loc': 'london',
      'date': '11/12/2022'
    },
  };

  @override
  void initState() {
    events = getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: 'District Events',
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TableCalendar(
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    todayDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('#3bb28d'),
                        shape: BoxShape.rectangle),
                    todayTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  headerStyle: HeaderStyle(
                      titleTextStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      titleCentered: true,
                      formatButtonVisible: false,
                      leftChevronIcon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 22,
                      ),
                      rightChevronIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 22,
                      )),
                  pageJumpingEnabled: true,
                  calendarFormat: CalendarFormat.week,
                  firstDay: DateTime.now().subtract(const Duration(days: 5)),
                  lastDay: DateTime.now().add(const Duration(days: 364)),
                  focusedDay: DateTime.now(),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<Events?>(
                  future: events,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CustomLoader());
                    }
                    if (snapshot.hasData &&
                        snapshot.data!.eventList!.isNotEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: ListView.builder(
                          itemCount: snapshot.data!.eventList!.length,
                          itemBuilder: (context, index) {
                            var eventlist = snapshot.data!.eventList;
                            var data = eventlist![index];
                            var firstData = eventlist.firstWhere((element) =>
                                element.eventDate == data.eventDate);
                            return Column(
                              children: [
                                data.id == firstData.id
                                    ? Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: HexColor('#dce1eb')),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: TextWidget(
                                            txt: data.eventDate ?? '',
                                            size: 12.sp,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 15.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 30.w,
                                              height: 15.h,
                                              decoration: BoxDecoration(
                                                  color:
                                                      //  data.activeStatus ==
                                                      //         false
                                                      //     ? HexColor('#3bb28d')
                                                      //     :
                                                      HexColor(_colors[index % 4]),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15, left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextWidget(
                                                      txt: data.eventTime ?? '',
                                                      size: 12.sp,
                                                      weight: FontWeight.w500,
                                                      clr:
                                                          //  data.activeStatus ==
                                                          //         false
                                                          //     ? Colors.white
                                                          //     :
                                                          Colors.black,
                                                    ),
                                                    const SizedBox(
                                                      height: 3,
                                                    ),
                                                    TextWidget(
                                                      txt: data.eventEndTime ??
                                                          '',
                                                      size: 10.sp,
                                                      weight: FontWeight.w500,
                                                      clr:
                                                          // data.activeStatus ==
                                                          //         false
                                                          //     ? Colors.white
                                                          //     :
                                                          Colors.black,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 64.4.w,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color:
                                                      // data.activeStatus == false
                                                      //     ? HexColor('#3bb28d')
                                                      //     :
                                                      Colors.white),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15, left: 20),
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextWidget(
                                                          txt:
                                                              data.eventTitle ??
                                                                  '',
                                                          size: 12.sp,
                                                          weight:
                                                              FontWeight.w500,
                                                          clr:
                                                              // data.activeStatus ==
                                                              //         false
                                                              //     ? Colors.white
                                                              //     :
                                                                   Colors
                                                                      .black,
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        SizedBox(
                                                          width: 55.w,
                                                          child: TextWidget(
                                                            maxlines: 4,
                                                            txt:
                                                                data.eventDes ??
                                                                    '',
                                                            size: 10.sp,
                                                            clr:
                                                                // data.activeStatus ==
                                                                //         false
                                                                //     ? Colors
                                                                //         .white
                                                                //     :
                                                                     Colors
                                                                        .black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                //  data.activeStatus ==
                                                                //         false
                                                                //     ? HexColor(
                                                                //         '#5cbfa0')
                                                                //     : 
                                                                    HexColor(
                                                                        '#ebecee')),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    data.eventLocation ==
                                                                            'Online Event'
                                                                        ? 'assets/svg/ONline white.svg'
                                                                        : 'assets/svg/Location White.svg',
                                                                    color: 
                                                                    // data.activeStatus ==
                                                                    //         false
                                                                    //     ? Colors
                                                                    //         .white
                                                                    //     : 
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  TextWidget(
                                                                    txt:
                                                                        data.eventLocation ??
                                                                            '',
                                                                    size: 8.sp,
                                                                    clr:
                                                                    //  data.activeStatus ==
                                                                    //         false
                                                                    //     ? Colors
                                                                    //         .white
                                                                    //     :
                                                                         HexColor(
                                                                            '#808082'),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 29.w,
                                        bottom: 0,
                                        child: data.activeStatus == false
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 6,
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  Container(
                                                    height: 8.h,
                                                    width: 1,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 6.8.h,
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                  const CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                  Container(
                                                    height: 6.8.h,
                                                    width: 2,
                                                    color: Colors.black,
                                                  )
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child:  TextWidget(txt:snapshot.hasData ? snapshot.data!.emptyEventMessage ?? '' : '',
                        align: TextAlign.center,
                        size: 12.sp,
                        weight: FontWeight.w500,)),
                      );
                    }
                  }),
            ),
          ],
        ));
  }

  Future<Events?>? getEvents() async {
    final response = await http.get(Uri.parse(InfixApi.getDistrictEvents()),
        headers: Utils.setHeader(_userDetailsController.token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return Events.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  }
}
