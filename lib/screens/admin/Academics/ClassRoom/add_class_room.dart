import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/ClassRoom/ClassRoomModel.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';

class AddClassRoom extends StatefulWidget {
  final bool? isEdit;
  final ClassRoomListModel? model;

  AddClassRoom({this.isEdit, this.model});

  @override
  _AddClassRoomState createState() => _AddClassRoomState();
}

class _AddClassRoomState extends State<AddClassRoom> {
  String? _id;
  int? _classRoomId;
  String? _token;
  bool isResponse = false;
  TextEditingController classController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit!) {
      print('Flag: isEdit');
      setState(() {
        _classRoomId = widget.model!.id;
        classController.text = widget.model!.roomNo!;
        capacityController.text = widget.model!.capacity.toString();
      });
    }

    _token = _userDetailsController.token;
    _id = _userDetailsController.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.isEdit! ? 'Update Class Room' : 'Add Class Room',
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 1,
                textAlign: TextAlign.start,
                controller: classController,
                decoration: InputDecoration(
                    hintText: 'Room No.',
                    alignLabelWithHint: true,
                    labelText: 'Room No.',
                    labelStyle: Theme.of(context).textTheme.headlineSmall,
                    errorStyle: const TextStyle(
                        color: Colors.pinkAccent, fontSize: 15.0),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF222744), width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 1,
                textAlign: TextAlign.start,
                controller: capacityController,
                decoration: InputDecoration(
                    hintText: 'Capacity',
                    alignLabelWithHint: true,
                    labelText: 'Capacity',
                    labelStyle: Theme.of(context).textTheme.headlineSmall,
                    errorStyle: const TextStyle(
                        color: Colors.pinkAccent, fontSize: 15.0),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF222744), width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        decoration: Utils.BtnDecoration,
                        child: Text(
                          'Save Class Room',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () async {
                      setState(() {
                        isResponse = true;
                      });
                      saveClassRoom();
                    }),
                isResponse == true
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                      )
                    : const Text(''),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveClassRoom() async {
    if (widget.isEdit!) {
      if (classController.text.isNotEmpty &&
          capacityController.text.isNotEmpty) {
        final parameter = {
          'id': _classRoomId,
          'room_no': classController.text,
          'capacity': capacityController.text,
        };
        print(parameter.entries);
        final response = await http.post(Uri.parse(InfixApi.updateClassRoom()),
            body: jsonEncode(parameter),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          // Utils.showSnackBar(context, 'Class Room updated Successfully!',
          //     color: Colors.green);
          Utils.showToast('Class Room updated Successfully!');
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (response.statusCode == 404) {
          // Utils.showSnackBar(context,
          //     'Class Room already taken, Please enter another Room no.!!!',
          //     color: Colors.red);
          Utils.showToast(
              'Class Room already taken, Please enter another Room no.!!!');
          setState(() {
            isResponse = false;
          });
        } else {
          throw Exception('Failed to load');
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
      } else {
        // Utils.showSnackBar(context, 'Please check all fields.',
        //     color: Colors.red);
        Utils.showToast('Please check all fields.');
      }
    } else {
      if (classController.text.isNotEmpty &&
          capacityController.text.isNotEmpty) {
        final parameter = {
          'room_no': classController.text,
          'capacity': capacityController.text,
        };
        print(parameter.entries);
        final response = await http.post(Uri.parse(InfixApi.assignClassRoom()),
            body: jsonEncode(parameter),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          // Utils.showSnackBar(context, 'Class Room Created Successfully!',
          //     color: Colors.green);
          Utils.showToast('Class Room Created Successfully!');
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (response.statusCode == 404) {
          // Utils.showSnackBar(context,
          //     'Class Room already taken, Please enter another Room no.!!!',
          //     color: Colors.red);
          Utils.showToast(
            'Class Room already taken, Please enter another Room no.!!!',
          );
          setState(() {
            isResponse = false;
          });
        } else {
          throw Exception('Failed to load');
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
      } else {
        // Utils.showSnackBar(context, 'Please check all fields.',
        //     color: Colors.red);
        Utils.showToast('Please check all fields.');
      }
    }
    /*if (widget.isEdit) {
      if (classController.text != null &&
          capacityController != null) {
        final parameter = {
          "start_time": _selectedStartTime,
          "id": _classTimeId,
          "period": (() {
            if (rememberMe) {
              return 'Break';
            } else {
              return controller.text;
            }
          }()),
          "end_time": _selectedEndTime,
          "type_name": _selectedTimeType,
          "is_break": (() {
            if (rememberMe) {
              return 1;
            }
          }()),
        };
        print(parameter.entries);
        final response = await http.post(Uri.parse(InfixApi.classTimeUpdate()),
            body: jsonEncode(parameter),
            headers: Utils.setHeader(_token.toString()));
            if (response.statusCode == 200) {
          Utils.showSnackBar(context, 'Class Time Updated Successfully!',
              color: Colors.green);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (response.statusCode == 404) {
          Utils.showSnackBar(context,
              'Time period already taken, Please select another time.!!!',
              color: Colors.red);
          setState(() {
            isResponse = false;
          });
        }  else {
          throw Exception('Failed to load');
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
      } else {
        Utils.showSnackBar(context, 'Please check all fields.',
            color: Colors.red);
      }
    }
    else{
      if (controller.text != null &&
          _selectedTimeType != null &&
          _selectedStartTime != null &&
          _selectedEndTime != null) {
        final parameter = {
          "start_time": _selectedStartTime,
          "period": (() {
            if (rememberMe) {
              return 'Break';
            } else {
              return controller.text;
            }
          }()),
          "end_time": _selectedEndTime,
          "type_name": _selectedTimeType,
          "is_break": (() {
            if (rememberMe) {
              return 1;
            }
          }()),
        };
        print(parameter.entries);
        final response = await http.post(Uri.parse(InfixApi.saveClassTime()),
            body: jsonEncode(parameter),
            headers: Utils.setHeader(_token.toString()));
            if (response.statusCode == 200) {
          Utils.showSnackBar(context, 'Class Time Saved Successfully!',
              color: Colors.green);
          Navigator.pop(context);
        } else if (response.statusCode == 404) {
          Utils.showSnackBar(context,
              'Time period already taken, Please select another time.!!!',
              color: Colors.red);
          setState(() {
            isResponse = false;
          });
        }  else {
          throw Exception('Failed to load');
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
      } else {
        Utils.showSnackBar(context, 'Please check all fields.',
            color: Colors.red);
      }
    }*/
  }
}
