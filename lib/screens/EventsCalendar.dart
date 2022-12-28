import 'package:flutter/material.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendar extends StatefulWidget {
  @override
  _EventsCalendarState createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF222744),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: 'Events & Calendar',
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                          BoxDecoration(color: Theme.of(context).primaryColor)),
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
              ],
            ),
          ),
        ));
  }
}
