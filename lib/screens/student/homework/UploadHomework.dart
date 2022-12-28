// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/exception/DioException.dart';
import 'package:nextschool/utils/model/StudentHomework.dart';

class UploadHomework extends StatefulWidget {
  final Homework? homework;
  final String? userID;

  UploadHomework({this.homework, this.userID});

  @override
  _UploadHomeworkState createState() => _UploadHomeworkState();
}

class _UploadHomeworkState extends State<UploadHomework> {
  // File _file;

  List<File>? files;
  List<String> fileNames = [];
  String? _token;
  bool isResponse = false;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  // double progress = 0.0;

  Future pickDocument(context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        files = result.paths.map((path) => File(path!)).toList();
        files!.forEach((element) {
          fileNames.add(element.path.toString().split('/').last);
        });
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  @override
  void initState() {
    _token = _userDetailsController.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Material(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          pickDocument(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.3)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: files == null
                                        ? Text(
                                            'Select Homework file',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(),
                                            maxLines: 2,
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                                files!.length,
                                                (index) => Text(
                                                      '$index - ${fileNames[index]}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4!
                                                          .copyWith(),
                                                    )),
                                          ),
                                  ),
                                ),
                                Text(
                                  'Browse',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          print(widget.homework!.id);
                          if (files != null) {
                            setState(() {
                              isResponse = true;
                            });
                            List<MultipartFile> multipart = [];

                            for (int i = 0; i < files!.length; i++) {
                              multipart.add(await MultipartFile.fromFile(
                                  files![i].path,
                                  filename: files![i].path));
                            }
                            // print(multipart);
                            FormData formData = FormData.fromMap({
                              'user_id': widget.userID,
                              'homework_id': widget.homework!.id,
                              'files[]': multipart,
                            });

                            Response response;
                            var dio = Dio();

                            response = await dio.post(
                              InfixApi.studentUploadHomework,
                              data: formData,
                              options: Options(
                                headers: {
                                  'Accept': 'application/json',
                                  'Authorization': _token.toString(),
                                },
                              ),
                              onSendProgress: (received, total) {
                                if (total != -1) {
                                  // progress = (received / total * 100).toDouble();
                                  print((received / total * 100)
                                          .toStringAsFixed(0) +
                                      '%');
                                }
                              },
                            ).catchError((e) {
                              final errorMessage =
                                  DioExceptions.fromDioError(e).toString();
                              print(errorMessage);
                              Utils.showToast(errorMessage);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });

                            print('Homework Submit ${response.statusCode}');
                            if (response.statusCode == 200) {
                              setState(() {
                                isResponse = false;
                              });
                              print(response.data);
                              var data = json.decode(response.toString());

                              print(data['success']);

                              print(data);
                              if (data['success'] == true) {
                                // Utils.showSnackBar(
                                //     context, 'Homework Upload successfully',
                                //     color: Colors.green);
                                Utils.showToast('Homework Upload successfully');
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                // Utils.showSnackBar(
                                //     context, 'Some error occurred');
                                Utils.showToast('Some error occurred');
                              }
                            } else {
                              setState(() {
                                isResponse = true;
                              });
                            }
                          } else {
                            // Utils.showSnackBar(context,
                            //     'Please select homework file before submit');
                            Utils.showToast(
                                'Please select homework file before submit');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(145),
                          height: ScreenUtil().setHeight(40),
                          decoration: Utils.BtnDecoration,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(Icons.cloud_upload),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Submit',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isResponse == true
                          ? const LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
