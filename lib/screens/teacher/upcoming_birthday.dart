import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/birthday.dart';

class UpcomingBirthDayScreen extends StatefulWidget {
  UpcomingBirthDayScreen({Key? key, required this.id, this.token})
      : super(key: key);
  var id;
  var token;
  @override
  State<UpcomingBirthDayScreen> createState() => _UpcomingBirthDayScreenState();
}

class _UpcomingBirthDayScreenState extends State<UpcomingBirthDayScreen> {
  Future<Birthdays?>? birthday;
  @override
  void initState() {
    birthday = fetchBirthday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Upcoming Birthdays'),
      body: FutureBuilder<Birthdays?>(
        future: birthday,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data!.data![index].firstName!),
                            Text(snapshot.data!.data![index].dateOfBirth!),
                            Text(snapshot
                                .data!.data![index].bdayTotalRemainingDays
                                .toString())
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const SizedBox();
            }
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Future<Birthdays?>? fetchBirthday() async {
    print('fetch birthday started');
    final response = await http.get(
        Uri.parse(InfixApi.getAllBirthday(widget.id)),
        headers: Utils.setHeader(widget.token));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return Birthdays.fromJson(jsonData);
    } else
      throw Exception('failed to load');
  }
}
