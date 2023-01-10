import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextschool/screens/frontseat/status_page/widgets/detail_card.dart';

import '../../../controller/kyc_step_model.dart';
import '../../../utils/Utils.dart';
import '../../../utils/apis/kyc_api.dart';
import '../../../utils/model/frontseat_user_detail_model.dart';
import '../../../utils/widget/DetailFields.dart';
import '../../../utils/widget/textwidget.dart';
import '../widgets/custom_appbar.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({Key? key}) : super(key: key);
  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  final kycStepModelController = Get.put(KycStepModel());
  Future<UserDetailModel?>? userdata;
  String? mobile;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileVerified;
  String? uploadDocuments;
  String? status;
  var image;
  var id;

  @override
  void initState() {
    Utils.getIntValue('id').then((value) {
      setState(() {
        id = value;
        userdata = KycApi.getUserDetails();
        // KycApi.AgentStatus(id);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: CustomAppbar(
          title: 'Status',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  FutureBuilder(
                      future: userdata,
                      builder:
                          (context, AsyncSnapshot<UserDetailModel?> snapshot) {
                        if (snapshot.data != null) {
                          var data = snapshot.data!.data!.agentDetails!;
                          mobile = data.mobile;
                          firstName = data.fullName ?? '';
                          email = data.email;
                          mobileVerified = data.mobileVerified.toString();
                          uploadDocuments = data.bankingDocument.toString();
                          // status = data.activeStatus.toString();
                        }
                        return Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 1,
                              shadowColor: Colors.grey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: const Color(0xffe3e3e3),
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextWidget(
                                          txt: 'Login Profile Details',
                                          clr: Colors.black,
                                          size: 18,
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, bottom: 20),
                                    child: Column(
                                      children: [
                                        DetailFields(
                                            title: 'Full Name : ',
                                            value: firstName ?? ''),
                                        // Visibility(
                                        //   visible: lastName != null &&
                                        //       lastName != '',
                                        //   child: DetailFields(
                                        //       title: 'Last Name : ',
                                        //       value: lastName ?? ''),
                                        // ),
                                        DetailFields(
                                            title: 'Phone Number : ',
                                            value: mobile ?? ''),
                                        DetailFields(
                                            title: 'Email :',
                                            value: email ?? ''),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Utils.sizedBoxHeight(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailCard(
                                  scale: .8,
                                  asset: 'assets/images/upload documents.png',
                                  title: 'Upload',
                                  title2: 'Documents',
                                  buttonColor: uploadDocuments == 'true'
                                      ? const Color(0xffd6ecdf)
                                      : const Color(0xffffd7d7),
                                  buttonText: uploadDocuments == 'true'
                                      ? 'Done'
                                      : 'Pending',
                                  buttonIcon: uploadDocuments == 'true'
                                      ? Icons.check_circle
                                      : Icons.alarm,
                                  buttonWidgetColor: uploadDocuments == 'true'
                                      ? const Color(0xff40a366)
                                      : const Color(0xfffb6869),
                                ),
                                DetailCard(
                                  scale: .8,
                                  asset: 'assets/images/application status.png',
                                  title: 'Application',
                                  title2: 'Status',
                                  buttonColor: status == 'Active'
                                      ? const Color(0xffd6ecdf)
                                      : status == 'Inreview'
                                          ? const Color.fromARGB(
                                              228, 255, 220, 114)
                                          : const Color(0xffffd7d7),
                                  buttonText: status == null
                                      ? 'Incomplete'
                                      : snapshot.hasData && status == 'new' ||
                                              status == 'pending' ||
                                              status == 'deactive'
                                          ? 'Pending Review'
                                          : status != null
                                              ? status!
                                              : 'Pending',
                                  buttonIcon: status == 'Active'
                                      ? Icons.check_circle
                                      : Icons.alarm,
                                  buttonWidgetColor: status == 'Active'
                                      ? const Color(0xff40a366)
                                      : status == 'Inreview'
                                          ? const Color.fromARGB(
                                              255, 200, 150, 0)
                                          : const Color(0xfffb6869),
                                ),
                              ],
                            ),
                            Utils.sizedBoxHeight(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const DetailCard(
                                  scale: .8,
                                  asset: 'assets/images/email verification.png',
                                  title: 'Email',
                                  title2: 'Verification',
                                  buttonColor: Color(0xffffd7d7),
                                  buttonText: 'Pending',
                                  buttonIcon: Icons.alarm,
                                  buttonWidgetColor: Color(0xfffb6869),
                                ),
                                DetailCard(
                                  scale: .58,
                                  asset: 'assets/images/phone verification.png',
                                  title: 'Phone',
                                  title2: 'Verification',
                                  buttonColor: mobileVerified == 'true'
                                      ? const Color(0xffd6ecdf)
                                      : const Color(0xffffd7d7),
                                  buttonText: mobileVerified == 'true'
                                      ? 'Done'
                                      : 'Pending',
                                  buttonIcon: mobileVerified == 'true'
                                      ? Icons.check_circle
                                      : Icons.alarm,
                                  buttonWidgetColor: mobileVerified == 'true'
                                      ? const Color(0xff40a366)
                                      : const Color(0xfffb6869),
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
