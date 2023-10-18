// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String? id;
  String? _token;
  bool _currentPasscodeVisible = false;
  bool _newPasscodeVisible = true;
  bool _confirmPasscodeVisible = false;
  bool isResponse = false;

  TextEditingController _currentPasscodeController = TextEditingController();
  TextEditingController _newPasscodeController = TextEditingController();
  TextEditingController _confirmPasscodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  UserDetailsController userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    id = userDetailsController.id.toString();
    _token = userDetailsController.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWidget(
          title: 'Change Passcode',
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        style: Theme.of(context).textTheme.titleLarge,
                        controller: _currentPasscodeController,
                        obscureText: _currentPasscodeVisible,
                        maxLength: 6,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (String? value) {
                          // RegExp regExp = new RegExp(r'^[0-9]*$');
                          if (value!.isEmpty) {
                            return 'Please enter your current Passcode';
                          }
                          if (value.length < 6) {
                            return 'Passcode must be at least 6 digit';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Enter your current Passcode',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Current Passcode',
                          labelStyle:
                              Theme.of(context).textTheme.headlineMedium,
                          errorStyle: const TextStyle(
                              color: Colors.pinkAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _currentPasscodeVisible =
                                    !_currentPasscodeVisible;
                              });
                            },
                            icon: Icon(
                              // Based on PasscodeVisible state choose the icon
                              _currentPasscodeVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        style: Theme.of(context).textTheme.titleLarge,
                        controller: _newPasscodeController,
                        obscureText: _newPasscodeVisible,
                        maxLength: 6,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (String? value) {
                          // RegExp regExp = new RegExp(r'^[0-9]*$');
                          if (value!.isEmpty) {
                            return 'Please enter a new Passcode';
                          }
                          if (value.length < 6) {
                            return 'Passcode must be at least 6 digit';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your new Passcode',
                          labelText: 'New Passcode',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle:
                              Theme.of(context).textTheme.headlineMedium,
                          errorStyle: const TextStyle(
                              color: Colors.pinkAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // suffixIcon: IconButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       _newPasscodeVisible = !_newPasscodeVisible;
                          //     });
                          //   },
                          //   icon: Icon(
                          //     _newPasscodeVisible
                          //         ? Icons.visibility
                          //         : Icons.visibility_off,
                          //     color: Theme.of(context).primaryColorDark,
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        style: Theme.of(context).textTheme.titleLarge,
                        controller: _confirmPasscodeController,
                        maxLength: 6,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        obscureText: _confirmPasscodeVisible,
                        validator: (String? value) {
                          // RegExp regExp = new RegExp(r'^[0-9]*$');
                          if (value!.isEmpty) {
                            return 'Please confirm your Passcode';
                          }
                          if (value.length < 6) {
                            return 'Passcode must be at least 6 digit';
                          }
                          if (value != _newPasscodeController.text) {
                            return 'New Passcode and confirm Passcode must be same.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm your new Passcode',
                          labelText: 'Confirm Passcode',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle:
                              Theme.of(context).textTheme.headlineMedium,
                          errorStyle: const TextStyle(
                              color: Colors.pinkAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _confirmPasscodeVisible =
                                    !_confirmPasscodeVisible;
                              });
                            },
                            icon: Icon(
                              _confirmPasscodeVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          errorMaxLines: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          decoration:
                              (_currentPasscodeController.text.isEmpty ||
                                      _newPasscodeController.text.isEmpty ||
                                      _confirmPasscodeController.text.isEmpty)
                                  ? BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                  : Utils.BtnDecoration,
                          child: Text(
                            'Change Passcode',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isResponse = true;
                            });

                            var form = {
                              'uid': userDetailsController.id,
                              'role_id': userDetailsController.roleId,
                              'current_password':
                                  _currentPasscodeController.text,
                              'new_password': _newPasscodeController.text,
                              'confirm_password':
                                  _confirmPasscodeController.text
                            };

                            //encode the form
                            var body = json.encode(form);
                            var response = await http.post(
                              Uri.parse(InfixApi.changePassword()),
                              body: body,
                              headers: Utils.setHeader(
                                _token.toString(),
                              ),
                            );

                            if (response.statusCode == 200) {
                              var data = jsonDecode(response.body);

                              if (data['success'] == true) {
                                Utils.showLoginToast(
                                    'Passcode changed successfully.');
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  isResponse = false;
                                });
                                Utils.showErrorToast(
                                    'You Entered Wrong Current Passcode');
                              }

                              setState(() {
                                _currentPasscodeController.clear();
                                _newPasscodeController.clear();
                                _confirmPasscodeController.clear();
                                isResponse = false;
                              });
                            } else if (response.statusCode == 404) {
                              setState(() {
                                isResponse = false;
                              });
                              Map<String, dynamic> data =
                                  (jsonDecode(response.body) as Map)
                                      as Map<String, dynamic>;

                              if (data['success'] == false) {
                                setState(() {
                                  isResponse = false;
                                });
                                Utils.showErrorToast(
                                    'You Entered Wrong Current Passcode');
                              }

                              setState(() {
                                _currentPasscodeController.clear();
                                _newPasscodeController.clear();
                                _confirmPasscodeController.clear();
                                isResponse = false;
                              });
                            }
                          } else {
                            Utils.showToast('Please fill all fields');
                          }
                        },
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
