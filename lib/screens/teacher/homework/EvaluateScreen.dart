// Flutter imports:
import 'dart:convert';

// Package imports:
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
// Project imports:
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/custom_widgets/CustomRadioButton/CustomButton/ButtonTextStyle.dart';
import 'package:nextschool/utils/custom_widgets/CustomRadioButton/custom_radio_button.dart';
import 'package:nextschool/utils/widget/Line.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class EvaluateScreen extends StatefulWidget {
  final String? studentName;
  final String? marks;
  final String? teacherComment;
  final String? status;
  final int? studentId;
  final int? homeworkId;
  final List<String>? files;
  final String? totalMarks;

  EvaluateScreen(
      {this.studentName,
      this.marks,
      this.teacherComment,
      this.status,
      this.studentId,
      this.homeworkId,
      this.files,
      this.totalMarks});

  @override
  _EvaluateScreenState createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  TextEditingController marksController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? selectedComment = '';
  String? selectedStatus = '';

  String evaluationDate = '';
  bool isResponse = false;

  Response? response;
  Dio dio = Dio();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  var id;
  var _token;

  @override
  void initState() {
    print({
      'studentName': widget.studentName,
      'marks': widget.marks,
      'teacher Comment': widget.teacherComment,
      'status': widget.status,
      'studentID': widget.studentId,
      'homework id': widget.homeworkId,
      'files': widget.files,
      'totalMarkse': widget.totalMarks
    });
    marksController.text = widget.marks!;
    print(marksController.text);
    selectedComment = widget.teacherComment;
    selectedStatus = widget.status;
    evaluationDate =
        '${DateTime.now().year}-${getAbsoluteDate(DateTime.now().month)}-${getAbsoluteDate(DateTime.now().day)}';
    print(evaluationDate);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _token = _userDetailsController.token;
    id = _userDetailsController.id.toString();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: widget.studentName,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /* TextFormField(
                      controller: marksController,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      style: Theme.of(context).textTheme.headline6,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String value) {
                        RegExp regExp = new RegExp(r'^[0-9]*$');
                        if (value.isEmpty) {
                          return 'Please enter a valid mark';
                        }
                        if (!regExp.hasMatch(value)) {
                          return 'Please enter a number';
                        }
                        if (int.tryParse(value) >
                            int.tryParse(widget.totalMarks)) {
                          return 'Marks must not greater than total marks';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Set Marks out of ${widget.totalMarks}",
                        labelText: "Set Marks out of ${widget.totalMarks}",
                        labelStyle: Theme.of(context).textTheme.headline4,
                        errorStyle:
                            TextStyle(color: Colors.pinkAccent, fontSize: 15.0),
                        errorMaxLines: 3,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),*/
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text('Comment',
                            style: Theme.of(context).textTheme.headline4),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomRadioButton(
                            defaultSelected: widget.teacherComment,
                            elevation: 0,
                            unSelectedColor: Theme.of(context).canvasColor,
                            buttonLables: [
                              'Good',
                              'Not Good',
                            ],
                            buttonValues: [
                              'G',
                              'NG',
                            ],
                            buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: const Color(0xff415094),
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(14))),
                            radioButtonValue: (dynamic value) {
                              print(value);
                              setState(() {
                                selectedComment = value;
                              });
                            },
                            selectedColor:
                                Theme.of(context).colorScheme.secondary,
                            enableShape: true,
                            customShape: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            horizontal: false,
                            width: ScreenUtil().setWidth(65),
                            height: ScreenUtil().setHeight(25),
                            enableButtonWrap: true,
                            wrapAlignment: WrapAlignment.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text('Homework Status',
                            style: Theme.of(context).textTheme.headline4),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomRadioButton(
                              defaultSelected: widget.status,
                              elevation: 0,
                              absoluteZeroSpacing: false,
                              unSelectedColor: Theme.of(context).canvasColor,
                              buttonLables: [
                                'Completed',
                                'Not Completed',
                              ],
                              buttonValues: [
                                'C',
                                'NC',
                              ],
                              buttonTextStyle: ButtonTextStyle(
                                  selectedColor: Colors.white,
                                  unSelectedColor: const Color(0xff415094),
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(14))),
                              radioButtonValue: (dynamic value) {
                                print(value);
                                setState(() {
                                  selectedStatus = value;
                                });
                              },
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
                              enableShape: true,
                              customShape: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              horizontal: false,
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setHeight(25),
                              enableButtonWrap: false,
                              wrapAlignment: WrapAlignment.start,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5),
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: ScreenUtil().setHeight(30),
                        decoration: Utils.BtnDecoration,
                        child: Text(
                          'Evaluate',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      onTap: () => evaluateSubmit(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isResponse == true
                        ? const LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                          )
                        : const Text(''),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.files!.length,
                      separatorBuilder: (context, index) {
                        return BottomLine();
                      },
                      itemBuilder: (context, index) {
                        return widget.files![index].contains('.pdf')
                            ? Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DownloadViewer(
                                                  title: 'PDF',
                                                  filePath: InfixApi().root +
                                                      widget.files![index],
                                                )));
                                  },
                                  child: Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      PdfView(
                                        path: InfixApi().root +
                                            widget.files![index],
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.deepPurple,
                                            ),
                                            Text(
                                              'View',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ExtendedImage.network(
                                InfixApi().root + widget.files![index],
                                fit: BoxFit.fill,
                                cache: true,
                                mode: ExtendedImageMode.gesture,
                                initGestureConfigHandler: (state) {
                                  return GestureConfig(
                                    minScale: 0.9,
                                    animationMinScale: 0.7,
                                    maxScale: 3.0,
                                    animationMaxScale: 3.5,
                                    speed: 1.0,
                                    inertialSpeed: 100.0,
                                    initialScale: 1.0,
                                    inPageView: true,
                                    initialAlignment: InitialAlignment.center,
                                  );
                                },
                                //cancelToken: cancellationToken,
                              );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  evaluateSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isResponse = true;
      });
      final response = await http.post(
        Uri.parse(InfixApi.evaluateHomework),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': _token.toString(),
        },
        body: jsonEncode(<String, dynamic>{
          'homework_id': widget.homeworkId.toString(),
          'student_id': [widget.studentId.toString()],
          'marks': [marksController.text],
          'teacher_comments': {
            '${widget.studentId}': selectedComment,
          },
          'homework_status': {
            '${widget.studentId}': selectedStatus,
          },
          'login_id': id,
          'evaluation_date': evaluationDate,
        }),
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'Homework Evaluation successfully') {
        // Utils.showSnackBar(
        //     context, 'Homework Evaluate done for ${widget.studentName}',
        //     color: Colors.green);
        Utils.showToast('Homework Evaluate done for ${widget.studentName}');
        setState(() {
          isResponse = false;
        });
        Navigator.of(context).pop();
      } else {
        // Utils.showSnackBar(context, 'Something went wrong');
        Utils.showToast('Something went wrong');
        setState(() {
          isResponse = false;
        });
      }
    }
  }
}
