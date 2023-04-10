import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:nextschool/screens/frontseat/profile_page/widgets/detail_field.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../../../utils/widget/textwidget.dart';
import '../model/frontseat_user_detail_model.dart';
import '../services/kyc_api.dart';

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
  String? residentialUnit;
  String? residentialStreet;
  String? residentialSuburb;
  String? residentialComplex;
  String? residentialProvince;
  String? residentialCity;
  String? residentialPostalCode;
  String? postalUnit;
  String? postalStreet;
  String? postalSuburb;
  String? postalComplex;
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
  String? nationality;
  String? country;
  String? idType;
  String? idNo;
  String? licenceNo;
  String? image;
  var id;

  @override
  void initState() {
    controller = TabController(length: 7, vsync: this);
    setState(() {
      userdata = KycApi.getUserDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const TextWidget(
          txt: 'Application Information',
          clr: Colors.white,
          size: 20,
          weight: FontWeight.w600,
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
                          var data = snapshot.data!.data!.agentDetails!;
                          image = data.agentPhoto;
                          name =
                              "${data.firstName ?? ''} ${data.lastName ?? ''}";
                          email = data.applicationEmail;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 40,
                                    backgroundImage: NetworkImage(image ==
                                                null ||
                                            image == ''
                                        ? 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQmcqzN9KSMx-hxPJfiB3yt59uQhN9R4IqjisfUEitJv9lbQVN14QYLsUfmgiH-AoH2VgTFMdRBaTWa9XXpU9aMV1fveYnRgRsf4peaqt_rCR_qyQ483NgjHHdhfYpOr8axyGWhk3DHw5lAUQkXl6NGMugPS7k6Apw7CUjqRMgwAv01i2_AXyRumuBfw/w680/blank-profile-picture-hd-images-photo.JPG'
                                        : image!),
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
                                  Tab(text: 'Work Details'),
                                  Tab(text: 'Identity Verification Details'),
                                  Tab(text: 'Supporting Documents'),
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
                      var data = snapshot.data!.data!.agentDetails!;
                      firstName = data.firstName;
                      middleName = data.middleName;
                      lastName = data.lastName;
                      passportNumber = data.passportNumber;
                      phoneNumber = data.applicationPhone;
                      email = data.applicationEmail;
                      gender = data.gender.toString();
                      maritalStatus = data.maritalStatus;
                      equityGroup = data.equityGroup;
                      dob = data.dateOfBirth;
                      residentialComplex = data.residentialComplex;
                      residentialStreet = data.residentialStreet;
                      residentialUnit = data.residentialUnit;
                      residentialSuburb = data.residentialSuburb;
                      residentialCity = data.residentialCity;
                      residentialPostalCode = snapshot
                          .data!.data!.agentDetails!.residentialPostalCode;
                      residentialProvince = snapshot
                          .data!.data!.agentDetails!.residentialprovince;
                      postalComplex = data.postalComplex;
                      postalStreet = data.postalStreet;
                      postalUnit = data.postalUnit;
                      postalSuburb = data.postalSuburb;
                      postalCity = data.postalCity;
                      postalPostalCode = data.postalPostalCode;
                      postalProvince = data.postalprovince;

                      emergencyContactFullName = snapshot
                          .data!.data!.agentDetails!.emergencyContactFullName;
                      emergencyContactNumber = snapshot
                          .data!.data!.agentDetails!.emergencyContactNumber;
                      emergencyAlternativeContactNumber = snapshot
                          .data!.data!.agentDetails!.emergencyAlternativeNumber;
                      accountType = data.accountType;
                      accountHolderRelation = snapshot
                          .data!.data!.agentDetails!.emergencyContactRelation;
                      bankName = data.bankName;
                      accHolderName = snapshot
                          .data!.data!.agentDetails!.bankAccountHolderName;
                      accNo = data.bankAccountNumber;
                      nationality = data.nationality;
                      country = data.countryOfBirth;
                      if (data.idNumber == '' && data.passportNo == '') {
                        idType = 'Asylum Document';
                        idNo = data.asylumDocNo;
                      } else if (data.asylumDocNo == '' &&
                          data.passportNo == '') {
                        idType = 'Rsa Id';
                        idNo = data.idNumber;
                      } else if (data.asylumDocNo == '' &&
                          data.idNumber == '') {
                        idType = 'Passport Document';
                        idNo = data.passportNo;
                      }

                      licenceNo = data.drivingLicenseId;
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
                                                icon: Icons.accessibility_new,
                                                title: 'Title',
                                                value: data.title ?? ''),
                                            DetailField(
                                                icon: Icons.person,
                                                title: 'First Name',
                                                value: firstName ?? ''),
                                            DetailField(
                                                icon: Icons.person,
                                                title: 'Middle Name',
                                                value: middleName ?? ''),
                                            DetailField(
                                                icon: Icons.person,
                                                title: 'Last Name',
                                                value: lastName ?? ''),
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
                                                icon: Icons.place_outlined,
                                                title: 'Nationality',
                                                value: nationality ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin,
                                                title: 'Martial Status',
                                                value: maritalStatus ?? ''),
                                            DetailField(
                                                icon: Icons.place,
                                                title: 'Country of Birth',
                                                value: country ?? ''),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: DetailField(
                                                  icon: Icons
                                                      .card_membership_sharp,
                                                  title: 'Disability',
                                                  value: data.disability ?? ''),
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
                                                title: 'Unit No',
                                                value: residentialUnit ?? ''),
                                            DetailField(
                                                icon: Icons.push_pin,
                                                title: 'Street',
                                                value: residentialStreet ?? ''),
                                            DetailField(
                                                icon: Icons.push_pin,
                                                title: 'Complex',
                                                value:
                                                    residentialComplex ?? ''),
                                            DetailField(
                                                icon: Icons.push_pin,
                                                title: 'Suburb',
                                                value: residentialSuburb ?? ''),
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
                                                    title: 'Unit No',
                                                    value: postalUnit ?? ''),
                                                DetailField(
                                                    icon: Icons.push_pin,
                                                    title: 'Street',
                                                    value: postalStreet ?? ''),
                                                DetailField(
                                                    icon: Icons.push_pin,
                                                    title: 'Complex',
                                                    value: postalComplex ?? ''),
                                                DetailField(
                                                    icon: Icons.push_pin,
                                                    title: 'Suburb',
                                                    value: postalSuburb ?? ''),
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
                                                icon: Icons.group,
                                                title: 'Relation',
                                                value:
                                                    data.emergencyContactRelation ??
                                                        ''),
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
                                                value:
                                                    data.bankBranchName ?? ''),
                                            DetailField(
                                                icon: Icons.phonelink,
                                                title: 'Branch Code',
                                                value:
                                                    data.bankBranchCode ?? ''),
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
                                            txt: 'Work Details',
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
                                                icon: Icons.person_pin_outlined,
                                                title: 'Equity Group',
                                                value: equityGroup ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin_outlined,
                                                title: 'Income Tax',
                                                value: data.incomeTax ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin_outlined,
                                                title: 'Preferred Work Address',
                                                value: data.workLocation ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin_outlined,
                                                title: 'Work City',
                                                value: data.workCity ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin_outlined,
                                                title: 'Work Province',
                                                value: data.workProvince ?? ''),
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
                                            txt:
                                                'Identity Verification Details',
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
                                                icon: Icons.person_pin_outlined,
                                                title: 'Identity Document Type',
                                                value: idType ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin_outlined,
                                                title: 'Identity Document No.',
                                                value: idNo ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin_outlined,
                                                title: 'Country Of Document',
                                                value: data.countryName ?? ''),
                                            DetailField(
                                                icon: Icons.person_pin_outlined,
                                                title: 'Driving License ID',
                                                value: data.drivingLicenseId ??
                                                    ''),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              itemCount: data.agentDocArray == null
                                  ? 0
                                  : data.agentDocArray!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data.agentDocArray![index].fileName ??
                                              '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.sp),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: 22.h,
                                        width: 200.w,
                                        child: CachedNetworkImage(
                                          imageUrl: data.agentDocArray![index]
                                                  .filePath ??
                                              '',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  GestureDetector(
                                            onTap: (() {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return Utils.documentViewer(
                                                    data.agentDocArray![index]
                                                            .filePath ??
                                                        '',
                                                    context);
                                              }));
                                            }),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return Utils.documentViewer(
                                                    data.agentDocArray![index]
                                                            .filePath ??
                                                        '',
                                                    context);
                                              }));
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: data
                                                      .agentDocArray![index]
                                                      .filePath ??
                                                  '',
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  // borderRadius:
                                                  //     const BorderRadius.all(Radius.circular(50)),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const CupertinoActivityIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Divider(
                                        thickness: 3,
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
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
