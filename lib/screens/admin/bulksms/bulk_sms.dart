// Dart imports:

// Package imports:
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Bloc/StaffListBloc.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Staff.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/submit_button.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

class BulkSMSScreen extends StatefulWidget {
  @override
  _BulkSMSScreenState createState() => _BulkSMSScreenState();
}

class _BulkSMSScreenState extends State<BulkSMSScreen> {
  String? _id;
  late StaffListBloc listBloc;

  bool isResponse = false;
  Response? response;
  FormData? formData;
  Dio dio = new Dio();
  String radioStr = 'student';
  String? _selectedStaffs;
  String? _token;
  String? errorMessage;
  String? successMessage;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  late SimulatedSubmitController submitController;

  @override
  void initState() {
    //initlize the submit controller
    submitController = SimulatedSubmitController(
      onOpenError: () {},
      onOpenSuccess: () {
        Utils.showSuccessBottomSheet(context, 'SMS sent successfully');
      },
      onPressed: onSubmit,
    );

    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
    listBloc = StaffListBloc(id: 5);
    listBloc.getStaffList();
    super.initState();
  }

  bool? isAllStaffSelected = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Bulk SMS',
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<StaffList>(
          stream: listBloc.getStaffSubject.stream,
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.error != null) {
                return _buildErrorWidget(snap.error.toString());
              }
              return getContent(context, snap.data!);
            } else if (snap.hasError) {
              return _buildErrorWidget(snap.error as String?);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CustomLoader());
  }

  Widget _buildErrorWidget(String? error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error occured: $error'),
      ],
    ));
  }

  Widget getContent(BuildContext context, StaffList data) {
    return ListView(
      padding: EdgeInsets.all(12.sp),
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 2000),
          opacity: 1,
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor('#d5dce0'),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CheckboxListTile(
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    title: Text(
                      'Send to all staffs',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                    value: isAllStaffSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isAllStaffSelected = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Visibility(
                    visible: !isAllStaffSelected!,
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 1,
                        ),
                        getStaffListDropDown(data.staffs),
                      ],
                    ),
                  ),
                ],
              )),
        ),
        SizedBox(
          height: 1.5.h,
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              // color: Color(0x604E88FF),
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            children: [
              Utils.sizedBoxWidth(8),
              Icon(
                Icons.info_outline,
                color: HexColor('#d5dce0'),
                size: 16.sp,
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                ('Login Credentials will be sent to all selected Staffs.'),
                style: TextStyle(
                  color: HexColor('#8e9aa6'),
                  fontSize: 10.sp,
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ).fontFamily,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        SizedBox(
          height: 50,
          child: AnimatedBuilder(
              animation: submitController,
              builder: (BuildContext context, Widget? child) {
                return SubmitButton(
                  text: 'Send SMS',
                  successText: 'SMS sent successfully',
                  status: submitController.submitStatus,
                  onPressed: submitController.onPressed,
                  onError: submitController.openError,
                  onSuccess: submitController.openSuccess,
                );
              }),
        ),
      ],
    );
  }

  Future<void> onSubmit() async {
    if (isAllStaffSelected! || _selectedStaffs!.length != null) {
      setState(() {
        submitController..submitStatus = SubmitStatus.disabled;
      });
      Dio dio = Dio(BaseOptions(
        headers: {'Authorization': _token.toString()},
        contentType: 'application/json',
      ));
      FormData formData = isAllStaffSelected!
          ? new FormData.fromMap({
              'selected_staff': 'all',
            })
          : new FormData.fromMap({
              'selected_ids': _selectedStaffs,
            });

      try {
        var response = await dio.post(
          InfixApi.sendBulkSMS(),
          data: formData,
        );
        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['success'] == true) {
            setState(() {
              submitController.submitStatus = SubmitStatus.success;
            });
          } else {
            errorMessage = response.data['message'];
            setState(() {
              submitController.submitStatus = SubmitStatus.error;
            });
          }
        }
      } on DioException catch (e) {
        setState(() {
          submitController.submitStatus = SubmitStatus.error;
        });
        switch (e.type) {
          case DioExceptionType.badResponse:
            {
              print(e.response!.data);
              print(e.response!.headers);
              print(e.response!.statusCode);
              errorMessage = e.response!.data['message'];
            }
            break;
          case DioExceptionType.sendTimeout:
            {
              errorMessage = e.message;
            }
            break;
          default:
            {
              errorMessage = e.message;
            }
        }
      }
    }
  }

  void sentNotificationToSection(int classCode, int sectionCode) async {
    final response = await http.get(Uri.parse(
        InfixApi.sentNotificationToSection(
            'Content', 'New content request has come', '$classCode')));
    if (response.statusCode == 200) {}
  }

  void sentNotificationTo(int role) async {
    final response = await http.get(Uri.parse(InfixApi.sentNotificationForAll(
        role, 'Content', 'New content request has come')));
    if (response.statusCode == 200) {}
  }

  Widget getStaffListDropDown(List<Staff> userDetails) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownSearch<String>.multiSelection(
        items: userDetails
            .map((e) => ((e.fullName).toLowerCase()).titleCase)
            .toList(),
        popupProps: PopupPropsMultiSelection.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              label: Text(
                'Search',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: HexColor('#d5dce0'),
                  fontFamily: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ).fontFamily,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: 8.sp,
                color: HexColor('#de5151'),
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#d5dce0'),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#5374ff'),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: HexColor('#de5151'),
                ),
              ),
              labelStyle: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          itemBuilder: (context, item, isSelected) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontFamily: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                      ).fontFamily,
                    ),
                  ),
                ),
                Divider(
                  color: HexColor('#8e9aa6'),
                  thickness: 0.5,
                )
              ],
            );
          },
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.black,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
          dropdownSearchDecoration: InputDecoration(
            label: Text(
              'Select Staff',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            ),
            errorStyle: TextStyle(
              fontSize: 8.sp,
              color: HexColor('#de5151'),
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#d5dce0'),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#5374ff'),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
          ),
        ),
        onChanged: (newValue) {
          _selectedStaffs = newValue
              .map((e) => userDetails
                  .firstWhere((element) =>
                      element.name.toLowerCase() == e.toLowerCase())
                  .userId)
              .join(',');
          log(_selectedStaffs.toString());
        },
        onSaved: (newValue) {
          if (newValue != []) {
            setState(() {
              //find the id of all selected items and store it in a string with comma separated
              _selectedStaffs = newValue!
                  .map((e) => userDetails
                      .firstWhere((element) =>
                          element.name.toLowerCase() == e.toLowerCase())
                      .userId)
                  .join(',');
              log(_selectedStaffs.toString());
            });
          }
        },
      ),
    );
  }
}
