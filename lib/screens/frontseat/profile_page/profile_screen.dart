import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:nextschool/screens/frontseat/profile_page/widgets/detail_field.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../../../utils/model/frontseat_user_detail_model.dart';
import '../../../utils/widget/textwidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.data}) : super(key: key);
  final UserDetailModel? data;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final kycStepModelController = Get.put(KycStepModel());
  TabController? controller;
  Future<UserDetailModel?>? userdata;
  String? name;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? phoneNumber;
  String? email;
  String? passportNumber;
  String? maritalStatus;
  String? equityGroup;
  String? dob;
  String? residentialAddress;
  String? residentialProvince;
  String? residentialCity;
  String? residentialPostalCode;
  String? postalAddress;
  String? postalProvince;
  String? postalCity;
  String? postalPostalCode;
  String? emergencyContactFullName;
  String? emergencyContactNumber;
  String? emergencyAlternativeContactNumber;
  String? accountType;
  String? accountHolderRelation;
  String? bankName;
  String? accHolderName;
  String? accNo;
  String? branchName;
  String? image;
  var id;

  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    Utils.getIntValue('id').then((value) {
      setState(() {
        id = value;
        // userdata = KycApi.getUserDetails(id);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const TextWidget(
          txt: 'Application Information',
          clr: Colors.white,
          size: 20,
          weight: FontWeight.w500,
        ),
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<UserDetailModel?>(
                      future: userdata,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.userData!;
                          image = data.profileImage;
                          name =
                              "${data.firstname ?? ''} ${data.lastname ?? ''}";
                          email = data.email;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 40,
                                    backgroundImage: NetworkImage(image ??
                                        'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQmcqzN9KSMx-hxPJfiB3yt59uQhN9R4IqjisfUEitJv9lbQVN14QYLsUfmgiH-AoH2VgTFMdRBaTWa9XXpU9aMV1fveYnRgRsf4peaqt_rCR_qyQ483NgjHHdhfYpOr8axyGWhk3DHw5lAUQkXl6NGMugPS7k6Apw7CUjqRMgwAv01i2_AXyRumuBfw/w680/blank-profile-picture-hd-images-photo.JPG'),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name == null ? '' : name!.capitalize!,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        email ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Utils.sizedBoxHeight(20),
                              TabBar(
                                splashFactory: InkRipple.splashFactory,
                                splashBorderRadius: BorderRadius.circular(30.0),
                                automaticIndicatorColorAdjustment: true,
                                labelColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                unselectedLabelColor: Colors.white,
                                indicator: const BoxDecoration(
                                  color: Color(0xffcd3639),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                controller: controller,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: const <Widget>[
                                  Tab(text: 'Personal Information'),
                                  Tab(text: 'Address'),
                                  Tab(text: 'Emergency Contact'),
                                  Tab(text: 'Bank Account Details'),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
            FutureBuilder<UserDetailModel?>(
                future: userdata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    if (snapshot.hasData) {
                      firstName = snapshot.data!.userData!.firstname;
                      // middleName = snapshot.data!.userData!.middleName;
                      lastName = snapshot.data!.userData!.lastname;
                      passportNumber = snapshot.data!.userData!.passportNumber;
                      phoneNumber = snapshot.data!.userData!.phonenumber;
                      email = snapshot.data!.userData!.email;
                      gender = snapshot.data!.userData!.gender;
                      maritalStatus = snapshot.data!.userData!.maritalStatus;
                      equityGroup = snapshot.data!.userData!.race;
                      dob = snapshot.data!.userData!.dateOfBirth;
                      residentialAddress =
                          snapshot.data!.userData!.residentialAddress;
                      residentialCity =
                          snapshot.data!.userData!.residentialTownCity;
                      residentialPostalCode =
                          snapshot.data!.userData!.residentialPostalCode;
                      residentialProvince =
                          snapshot.data!.userData!.residentialProvince;
                      postalAddress = snapshot.data!.userData!.postalAddress;
                      postalCity = snapshot.data!.userData!.postalTownCity;
                      postalPostalCode = snapshot.data!.userData!.postalCode;
                      postalProvince = snapshot.data!.userData!.postalProvince;

                      emergencyContactFullName =
                          snapshot.data!.userData!.emergencyContactsFullName;
                      emergencyContactNumber =
                          snapshot.data!.userData!.emergencyMobileNo;
                      emergencyAlternativeContactNumber =
                          snapshot.data!.userData!.emergencyAlternativeNo;
                      accountType = snapshot.data!.userData!.accountType;
                      accountHolderRelation =
                          snapshot.data!.userData!.accountHolderRelationship;
                      bankName = snapshot.data!.userData!.bankName;
                      accHolderName = snapshot.data!.userData!.accountHolder;
                      accNo = snapshot.data!.userData!.accountNumber;
                      branchName = snapshot.data!.userData!.branchName;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: TabBarView(controller: controller, children: [
                            ListView(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  shadowColor: Colors.grey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: const Color(0xffe3e3e3),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextWidget(
                                            txt: 'Personal Details',
                                            clr: Colors.black,
                                            size: 18,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            DetailField(
                                                icon: Icons.person,
                                                title: 'Full Name',
                                                value: firstName == null
                                                    ? ' '
                                                    : '$firstName ${middleName ?? ""} ${lastName ?? ''}'
                                                        .capitalize!),
                                            DetailField(
                                                icon: Icons.calendar_month,
                                                title: 'Date of Birth',
                                                value: dob ?? ''),
                                            DetailField(
                                                icon: Icons
                                                    .phone_android_outlined,
                                                title: 'Phone Number',
                                                value: phoneNumber ?? ''),
                                            DetailField(
                                                icon: Icons.email,
                                                title: 'Email',
                                                value: email ?? ''),
                                            DetailField(
                                                icon: Icons.people,
                                                title: 'Gender',
                                                value: gender ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin,
                                                title: 'Martial Status',
                                                value: maritalStatus ?? ''),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: DetailField(
                                                  icon:
                                                      Icons.person_pin_outlined,
                                                  title: 'Equity Group',
                                                  value: equityGroup ?? ''),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ListView(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  shadowColor: Colors.grey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: const Color(0xffe3e3e3),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextWidget(
                                            txt: 'Address',
                                            clr: Colors.black,
                                            size: 18,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        color: const Color(0xffd8d8d8),
                                        child: const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: TextWidget(
                                            txt: 'Residential Address',
                                            clr: Colors.black,
                                            size: 15,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            DetailField(
                                                icon: Icons.push_pin,
                                                title: 'Address',
                                                value:
                                                    residentialAddress ?? ''),
                                            DetailField(
                                                icon: Icons.place,
                                                title: 'City',
                                                value: residentialCity ?? ''),
                                            DetailField(
                                                icon: Icons.location_city,
                                                title: 'Province',
                                                value:
                                                    residentialProvince ?? ''),
                                            DetailField(
                                                icon: Icons.local_post_office,
                                                title: 'Postal Code',
                                                value: residentialPostalCode ??
                                                    ''),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            color: const Color(0xffd8d8d8),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5),
                                              child: TextWidget(
                                                txt: 'Postal Address',
                                                clr: Colors.black,
                                                size: 15,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                DetailField(
                                                    icon: Icons.push_pin,
                                                    title: 'Address',
                                                    value: postalAddress ?? ''),
                                                DetailField(
                                                    icon: Icons.place,
                                                    title: 'City',
                                                    value: postalCity ?? ''),
                                                DetailField(
                                                    icon: Icons.location_city,
                                                    title: 'Province',
                                                    value:
                                                        postalProvince ?? ''),
                                                DetailField(
                                                    icon:
                                                        Icons.local_post_office,
                                                    title: 'Postal Code',
                                                    value:
                                                        postalPostalCode ?? ''),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ListView(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  shadowColor: Colors.grey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: const Color(0xffe3e3e3),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextWidget(
                                            txt: 'Emergency Contact',
                                            clr: Colors.black,
                                            size: 18,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            DetailField(
                                                icon: Icons.person,
                                                title: 'Name',
                                                value:
                                                    emergencyContactFullName ??
                                                        ''),
                                            DetailField(
                                                icon: Icons.phone,
                                                title: 'Phone Number',
                                                value: emergencyContactNumber ??
                                                    ''),
                                            DetailField(
                                                icon: Icons.phone,
                                                title: 'Alternate Number',
                                                value:
                                                    emergencyAlternativeContactNumber ??
                                                        ''),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ListView(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 1,
                                  shadowColor: Colors.grey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: const Color(0xffe3e3e3),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextWidget(
                                            txt: 'Bank Account Details',
                                            clr: Colors.black,
                                            size: 18,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            DetailField(
                                                icon: Icons.person,
                                                title: 'Account Holder\nName',
                                                value: accHolderName ?? ''),
                                            DetailField(
                                                icon: Icons.people_alt_rounded,
                                                title:
                                                    'Account Holder\nRelation',
                                                value: accountHolderRelation ??
                                                    ''),
                                            DetailField(
                                                icon: Icons.key_outlined,
                                                title: 'Account Number',
                                                value: accNo ?? ''),
                                            DetailField(
                                                icon: Icons.merge_type_rounded,
                                                title: 'Account Type',
                                                value: accountType ?? ''),
                                            DetailField(
                                                icon: Icons.place,
                                                title: 'Bank Name',
                                                value: bankName ?? ''),
                                            DetailField(
                                                icon: Icons.phonelink,
                                                title: 'Branch Name',
                                                value: branchName ?? ''),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      );
                    } else {
                      return const Expanded(
                          child: Center(
                              child: TextWidget(
                        txt: 'No Data Found',
                      )));
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}
