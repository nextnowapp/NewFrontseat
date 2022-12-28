// Flutter imports:
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoutineRowDesign extends StatelessWidget {
  String time;
  String? subject;
  String? room;

  RoutineRowDesign(this.time, this.subject, {this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              // flex: 4,
              child: Center(
                child: Text(time,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              // flex: 4,
              child: Center(
                child: Text(subject!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            /*Expanded(
              // flex: 2,
              child: Center(
                child: Text(room,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600)),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
