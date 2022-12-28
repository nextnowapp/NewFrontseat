import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/screens/admin/Merits&Demerits/add_remarks.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../controller/user_controller.dart';
import '../../../utils/Utils.dart';

class ViewRemarks extends StatefulWidget {
  ViewRemarks({this.id, Key? key}) : super(key: key);
  String? id;

  @override
  State<ViewRemarks> createState() => _ViewRemarksState();
}

class _ViewRemarksState extends State<ViewRemarks>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  String? _token;
  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());
  late Future remarks;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    _token = userDetailsController.token;
    remarks = getAllRemarks();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    super.initState();
  }

  Future getAllRemarks() async {
    final response = await http.get(
        Uri.parse(InfixApi.getAllMerits(widget.id.toString())),
        headers: Utils.setHeader(_token.toString()));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load');
    }
  }

  ImageProvider<Object>? getImage(String image) {
    if (image.isNotEmpty) {
      // return NetworkImage(InfixApi().root + this.widget .image!);
      return CachedNetworkImageProvider(
        InfixApi().root + image,
      );
    } else {
      return const AssetImage('assets/images/parent.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Merit\'s Leaderboard',
        ),
        body: Padding(
          padding: EdgeInsets.all(12.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                FutureBuilder(
                  future: remarks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var raw = snapshot.data as Map<String, dynamic>;
                      var data = raw['data'] as Map<String, dynamic>;
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  const BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.black12,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              height: 130,
                              child: Center(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  minVerticalPadding: 0,
                                  horizontalTitleGap: 0,
                                  leading: CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage: getImage(
                                        data['student_photo'].toString()),
                                    backgroundColor: Colors.grey,
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: HexColor('#3ab28d'),
                                          ),
                                          child: Text(
                                            data['merit_count'].toString() +
                                                ' Merits',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: HexColor('#ffbd39'),
                                          ),
                                          child: Text(
                                            data['demerit_count'].toString() +
                                                ' Demerits',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Class:' + data['student_class'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('#94a4b9')),
                                  ),
                                  title: Text(
                                    data['student_name'].toString(),
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              color: Colors.white,
                              boxShadow: [
                                const BoxShadow(
                                  blurRadius: 1,
                                  color: Colors.black12,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TableCalendar(
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay:
                                  DateTime.now().add(const Duration(days: 365)),
                              focusedDay: _focusedDay,
                              currentDay: _selectedDay,
                              availableGestures: AvailableGestures.all,
                              availableCalendarFormats: const {
                                CalendarFormat.month: 'Month',
                                CalendarFormat.week: 'Week',
                              },
                              calendarFormat: CalendarFormat.month,
                              calendarStyle: const CalendarStyle(
                                outsideDaysVisible: true,
                                canMarkersOverflow: true,
                                isTodayHighlighted: true,
                              ),
                              headerStyle: HeaderStyle(
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  color: const Color(0xFF0a0a0a),
                                  fontFamily: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ).fontFamily,
                                  fontSize: 20,
                                ),
                                formatButtonVisible: false,
                                leftChevronVisible: true,
                                rightChevronVisible: true,
                                leftChevronIcon: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor('#edeff3'),
                                  ),
                                  child: const Icon(Icons.chevron_left,
                                      color: Color(0xFF0a0a0a)),
                                ),
                                rightChevronIcon: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor('#edeff3'),
                                  ),
                                  child: const Icon(Icons.chevron_right,
                                      color: Color(0xFF0a0a0a)),
                                ),
                              ),
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                  weekendStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 8.sp,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                    ).fontFamily,
                                  ),
                                  weekdayStyle: TextStyle(
                                    color: const Color(0xff4E88FF),
                                    fontSize: 8.sp,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                    ).fontFamily,
                                  )),
                              onDaySelected: (date, events) {
                                setState(() {
                                  _selectedDay = date;
                                  _focusedDay = events;
                                });
                              },
                              calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, date, events) {
                                var remarkList = data['remark'] as List;
                                var remarkDateList = remarkList
                                    .map((e) => e['remark_date'])
                                    .toList();
                                var formattedDate =
                                    DateFormat('dd/MM/yyyy').format(date);
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(300.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: const TextStyle(
                                            color: Colors.black87),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      child: Visibility(
                                          visible: remarkDateList
                                              .contains(formattedDate),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children:
                                                getEventCounDotList(data, date),
                                          )),
                                    ),
                                  ],
                                );
                              }, todayBuilder: (context, date, events) {
                                var remarkList = data['remark'] as List;
                                var remarkDateList = remarkList
                                    .map((e) => e['remark_date'])
                                    .toList();
                                var formattedDate =
                                    DateFormat('dd/MM/yyyy').format(date);

                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4E88FF),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: const TextStyle(
                                            color: Colors.black87),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      child: Visibility(
                                          visible: remarkDateList
                                              .contains(formattedDate),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children:
                                                getEventCounDotList(data, date),
                                          )),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: HexColor('#eff4ff'),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Merits/Demerits',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      //calendar icon with date
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  color: HexColor('#edeff3'),
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/images/calendar-2852107 (2).svg',
                                                  width: 18,
                                                  color: HexColor('#8395ae'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yyyy')
                                                    .format(_selectedDay),
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontFamily: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                  ).fontFamily,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...getRemarkList(data),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> getEventCounDotList(data, DateTime date) {
    var remarkList = data['remark'] as List;
    //find remark list for selected date
    var selectedDateRemarkList = remarkList
        .where((element) =>
            DateFormat('dd/MM/yyyy').format(date) == element['remark_date'])
        .toList();
    // return List.generate(
    //   remarkDateList.length,
    //   (index) => Container(
    //     margin: const EdgeInsets.only(right: 5),
    //     width: 5,
    //     height: 5,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(5),
    //       color: HexColor('#ffbd39'),
    //     ),
    //   ),
    // );
    return List.generate(
      selectedDateRemarkList.length,
      (index) => Container(
        margin: const EdgeInsets.only(right: 5),
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selectedDateRemarkList[index]['merits_type'] == '1'
              ? HexColor('#00b58b')
              : HexColor('#ffba00'),
        ),
      ),
    );
  }

  List<Widget> getRemarkList(data) {
    var remarkList = data['remark'] as List;
    //find remark list for selected date
    var selectedDateRemarkList = remarkList
        .where((element) =>
            DateFormat('dd/MM/yyyy').format(_selectedDay) ==
            element['remark_date'])
        .toList();
    return List.generate(
      selectedDateRemarkList.length,
      (index) => Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          border: (index < 1)
              ? const Border(
                  bottom: BorderSide(
                  color: Colors.black12,
                  width: 0.5,
                ))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              //star icon
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  color: selectedDateRemarkList[index]['merits_type'] == '1'
                      ? HexColor('#00b58b')
                      : HexColor('#ffba00'),
                ),
                child: Icon(
                  selectedDateRemarkList[index]['merits_type'] == '1'
                      ? Icons.star_rounded
                      : Icons.warning_amber_rounded,
                  color: Colors.white,
                  // 00b58b
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              //text
              Container(
                width: 50.w,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  color: selectedDateRemarkList[index]['merits_type'] == '1'
                      ? HexColor('#00b58b')
                      : HexColor('#ffba00'),
                ),
                child: Text(
                  selectedDateRemarkList[index]['merits_type'] == '1'
                      ? 'Merit'
                      : 'Demerit',
                  style: TextStyle(
                    color: Colors.white,
                    // 00b58b
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                    ).fontFamily,
                  ),
                ),
              ),
            ]),
            const SizedBox(
              height: 12,
            ),
            Text(
              selectedDateRemarkList[index]['remarks'].toString(),
              style: TextStyle(
                color: Colors.black87,
                // 00b58b
                fontSize: 10.sp,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                ).fontFamily,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: HexColor('#edeff3'),
                    //add bottom border
                  ),
                  child: Text(
                    selectedDateRemarkList[index]['assigned_by'].toString(),
                    style: TextStyle(
                      color: HexColor('#8d9fb5'),
                      // 00b58b
                      fontSize: 8.sp,
                      fontFamily: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ).fontFamily,
                    ),
                  ),
                ),
                Row(
                  children: [
                    //delete and edit
                    InkWell(
                      onTap: () {
                        //navigate to edit remark screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRemarksScreen(
                              isEdit: true,
                              data: selectedDateRemarkList[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: HexColor('#edeff3'),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black87,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        showDeleteAlertDialog(context,
                            selectedDateRemarkList[index]['id'] as int);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: HexColor('#edeff3'),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red[200],
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String parseDate(DateTime date) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
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
              deleteMeritDemerit(id);
            });
          },
          title: 'Delete Homework',
        );
      },
    );
  }

  Future<void> deleteMeritDemerit(int id) async {
    final response = await http.get(Uri.parse(InfixApi.deleteMerit(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var msg = jsonData['message'];
      Utils.showToast(msg);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      var jsonData = jsonDecode(response.body);
      var msg = jsonData['message'];
      Utils.showToast(msg);
      throw Exception('failed to load');
    }
  }
}
