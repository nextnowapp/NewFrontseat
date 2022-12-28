import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/signup_flow/password_form.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widget/back_button.dart';
import '../../utils/widget/next_button.dart';
import '../../utils/widget/textwidget.dart';

class LearnerRegistrationDetailsScreen extends StatefulWidget {
  const LearnerRegistrationDetailsScreen(
      {required this.map,
      required this.userData,
      required this.schoolLogo,
      Key? key,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.email,
      required this.cls,
      required this.gender,
      required this.dob,
      required this.number,
      required this.id})
      : super(key: key);
  final Map<String, dynamic> map;
  final Map<String, dynamic> userData;
  final String schoolLogo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String cls;
  final String gender;
  final String dob;
  final String number;
  final String id;

  @override
  State<LearnerRegistrationDetailsScreen> createState() =>
      _LearnerRegistrationDetailsScreenState();
}

class _LearnerRegistrationDetailsScreenState
    extends State<LearnerRegistrationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.schoolLogo,
                  width: 60.w,
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 10,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, top: 10, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    DetailRow(title: 'First Name:', value: widget.firstName),
                    DetailRow(title: 'Middle Name:', value: widget.middleName),
                    DetailRow(title: 'Last Name:', value: widget.lastName),
                    DetailRow(title: 'E-mail:', value: widget.email),
                    DetailRow(title: 'RSA ID:', value: widget.id),
                    DetailRow(title: 'Phone No:', value: widget.number),
                    DetailRow(title: 'Gender:', value: widget.gender),
                    DetailRow(title: 'Date of Birth:', value: widget.dob),
                    DetailRow(title: 'Class:', value: widget.cls),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: BackBtn(
                              color: HexColor('#3fb18f'),
                              textColor: HexColor('#3fb18f'),
                            )),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordFormScreen(
                                        schoolLogo: widget.schoolLogo,
                                        map: widget.map,
                                        fullName: widget.firstName +
                                            ' ' +
                                            widget.middleName +
                                            ' ' +
                                            widget.lastName,
                                        userData: widget.userData,
                                      )),
                            );
                          },
                          child: NextButton(
                            color: HexColor('#3fb18f'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class DetailRow extends StatelessWidget {
  DetailRow({Key? key, required this.title, required this.value})
      : super(key: key);
  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: TextWidget(
                  txt: title,
                  weight: FontWeight.w600,
                  size: 16,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: TextWidget(
                  txt: value,
                  weight: FontWeight.w600,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
