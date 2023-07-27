import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

class EditOthersProfile extends StatefulWidget {
  String? height;
  String? weight;
  String? id;
  String? learnerdob;
  String? parent1dob;

  EditOthersProfile(
      {Key? key,
      required this.height,
      required this.weight,
      this.id,
      this.learnerdob,
      this.parent1dob})
      : super(key: key);

  @override
  State<EditOthersProfile> createState() => _EditOthersProfileState();
}

class _EditOthersProfileState extends State<EditOthersProfile> {
  var heightController;
  var weightController;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    heightController = TextEditingController(text: widget.height);
    weightController = TextEditingController(text: widget.weight);
    super.initState();
    _token = _userDetailsController.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        showNotification: false,
        title: 'Edit Others ',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.sp,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                TxtField(
                  hint: 'Enter Height',
                  controller: heightController,
                  // value: widget.height,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Height';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.sp,
                ),
                TxtField(
                  hint: 'Enter Weight',
                  controller: weightController,
                  // value: widget.weight,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Middle name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.sp,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: HexColor('#5374ff'),
          borderRadius: BorderRadius.circular(20.0),
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () async {
              updateLearner();
              Utils.showProcessingToast();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: Text(
                  'Submit',
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
          ),
        ),
      ),
    );
  }

  updateLearner() async {
    FormData parameter = FormData.fromMap({
      'id': widget.id,
      'height': heightController.text,
      'weight': weightController.text,
      'page': 'others',
    });
    Dio dio = Dio(BaseOptions(
      headers: Utils.setHeader(_token.toString()),
      contentType: 'application/json',
    ));
    var response = await dio.post(
      InfixApi.updateLearner(),
      data: parameter,
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioException(e).toString();
      setState(() {});
      Utils.showToast(errorMessage);
    });
    print(response.data);
    if (response.statusCode == 200) {
      Utils.showToast('Learner updated Successfully!');
      setState(() {});
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      Utils.showToast('Failed to update learner');
      setState(() {});
    } else {
      throw Exception('Failed to load');
    }
  }
}
