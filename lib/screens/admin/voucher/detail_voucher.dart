import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/txtbox.dart';

class DetailVoucher extends StatefulWidget {
  int? addmissionNo;
  String? passcode1;
  String? passcode2;

  DetailVoucher({Key? key, this.addmissionNo, this.passcode1, this.passcode2})
      : super(key: key);

  @override
  State<DetailVoucher> createState() => _DetailVoucherState();
}

class _DetailVoucherState extends State<DetailVoucher> {
  TextEditingController userInput = TextEditingController();
  String? _token;
  late Future<String?> data;
  final _formKey = GlobalKey<FormState>();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  int? group = 1;

  @override
  void initState() {
    _token = _userDetailsController.token;
    data = postVouchers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _refresh() async {
      setState(() {
        data = postVouchers();
      });
    }

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'Voucher Detail'),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Padding(
            padding: EdgeInsets.all(12.sp),
            child: ListView(
              children: [
                FutureBuilder<String?>(
                    future: data,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                ' Current voucher code :',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                              ),
                              SizedBox(
                                height: 40.h,
                              ),
                              Text(
                                snapshot.data!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: ScreenUtil().setSp(32),
                                    ),
                              ),

                              SizedBox(
                                height: 80.h,
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.sp),
                                child: Form(
                                  key: _formKey,
                                  child: TxtField(
                                    onChanged: (value) {
                                      userInput.value = TextEditingValue(
                                          text: userInput.text.toUpperCase(),
                                          selection: userInput.selection);
                                    },
                                    hint: 'Enter Voucher Code',
                                    controller: userInput,
                                    validator: (value) {
                                      // String? message;
                                      if (value == null) {
                                        return 'please enter voucher code';
                                      } else if (value.length < 12) {
                                        return 'The Voucher Code must be at least 12 characters';
                                      }
                                      return null;
                                    },
                                    length: 12,
                                    type: TextInputType.text,
                                    formatter: [
                                      LengthLimitingTextInputFormatter(12),
                                      FilteringTextInputFormatter
                                          .singleLineFormatter,
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9]')),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 200,
                              ),

                              // getvoucher(snapshot.data!.data![0].tP2Pass)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, left: 20, top: 10, bottom: 10),
                                child: Material(
                                  color: HexColor('#5374ff'),
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50.0,
                                        child: Text(
                                          'Update Voucher',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (_formKey.currentState!.validate()) {
                                          updateVouchers(userInput.text);
                                        }
                                      }); // Utils.saveStringValue('password', userInput.text);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Text('no data');
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
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> postVouchers() async {
    Dio dio = new Dio();

    var response = await dio
        .post(
      InfixApi.detail,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = e.response!.data['message'];
      Utils.showErrorToast(errorMessage);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
    print('==============${response.data}====================');
    if (response.statusCode == 200) {
      var data = response.data;
      var otp = data['data']['school_registration_otp'].toString();
      return otp;
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future updateVouchers(var voucher) async {
    Dio dio = new Dio();

    var response = await dio.post(
      InfixApi.voucherCode,
      data: {
        'passcode': voucher,
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': _token.toString(),
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          // progress = (received / total * 100).toDouble();
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      final errorMessage = e.response!.data['message'];
      print(errorMessage);
      Utils.showErrorToast(errorMessage);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
    print('${response.data}');
    print('statuscode = ${response.statusCode}');
    if (response.statusCode == 200) {
      Utils.showToast(response.data['message']);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
