// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Subject.dart';
import 'package:nextschool/utils/widget/SubjectRowLayout.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class SubjectScreen extends StatefulWidget {
  String? id;

  SubjectScreen({this.id});

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  Future<SubjectList?>? subjects;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  String? _token;

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        subjects = getAllSubject(
            widget.id != null ? int.parse(widget.id!) : int.parse(value!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: '',
        appBarColor: HexColor('#e8faf7'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Container(
                height: size.height * 0.11,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: HexColor('#e8faf7'))),
            Positioned(
              top: -75,
              left: -10,
              child:
                  SvgPicture.asset('assets/images/Subject List Top Image.svg'),
              height: size.height * 0.2,
            ),
            Positioned(
                top: 30,
                left: 230,
                child: Text(
                  'Subjects',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: HexColor('#2b304c')),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: FutureBuilder<SubjectList?>(
                future: subjects,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.subjects.length > 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: snapshot.data!.subjects.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 4, right: 4),
                              child: SubjectRowLayout(
                                  snapshot.data!.subjects[index], index),
                            );
                          },
                        ),
                      );
                    } else {
                      return Utils.noDataTextWidget();
                    }
                  } else {
                    return const Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CustomLoader(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<SubjectList?>? getAllSubject(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getSubjectsUrl(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = jsonDecode(response.body);
      if (jsonData['data']['student_subjects'] == null) {
        return SubjectList([]);
      } else {
        return SubjectList.fromJson(jsonData['data']['student_subjects']);
      }
    } else {
      throw Exception('Failed to load');
    }
  }
}
