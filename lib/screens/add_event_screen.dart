import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/model/event_model.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../utils/apis/Apis.dart';
import '../utils/widget/date_selector_textfield.dart';
import '../utils/widget/txtbox.dart';

class AddEventScreen extends StatefulWidget {
  late final bool isEdit;
  final EventsData? data;
  AddEventScreen(
      {required this.token, this.isEdit = false, this.data, Key? key})
      : super(key: key);
  String? token;
  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  var _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  bool? isResponse;
  String? sendTo;

  initState() {
    if (widget.isEdit) {
      titleController.text = widget.data!.eventTitle!;
      descriptionController.text = widget.data!.eventDes!;
      locationController.text = widget.data!.eventLocation!;
      fromDateController.text = widget.data!.fromDate!;
      toDateController.text = widget.data!.toDate!;
      sendTo = widget.data!.forWhom!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Add Event',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TxtField(
                  hint: 'Title',
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Title';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DateSelectorTextField(
                  controller: fromDateController,
                  onDateSelected: (date) {
                    fromDateController.text = date;
                  },
                  locale: _locale,
                  title: 'From',
                  validatorMessage: 'Please select from date',
                ),
                const SizedBox(
                  height: 10,
                ),
                DateSelectorTextField(
                  controller: toDateController,
                  onDateSelected: (date) {
                    toDateController.text = date;
                  },
                  locale: _locale,
                  title: 'To',
                  validatorMessage: 'Please select to date',
                ),
                const SizedBox(
                  height: 20,
                ),
                sendToDropDown(),
                const SizedBox(
                  height: 10,
                ),
                TxtField(
                  hint: 'Location',
                  controller: locationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Location';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TxtField(
                  hint: 'Description',
                  lines: 3,
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(12.sp),
            child: RoundedLoadingButton(
              width: 100.w,
              borderRadius: 20,
              color: Colors.blue,
              controller: _btnController,
              onPressed: () {
                if (_formKey.currentState!.validate() && sendTo != null) {
                  addEvent();
                } else {
                  Utils.showToast('please add every details');
                  _btnController.reset();
                }
              },
              child: Text(widget.isEdit ? 'Update Event' : 'Add Event',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget sendToDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send To',
          style: TextStyle(
            color: HexColor('#8e9aa6'),
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>(
          // mode: Mode.MENU,
          validator: (value) {
            if (value == null) {
              return 'Please select send to';
            }
            return null;
          },
          // showSelectedItems: true,
          items: ['All', 'Parents', 'Management', 'Teachers'],
          popupProps: const PopupProps.menu(
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (4 * 60) < 200 ? (4 * 60) : 200,
            ),
          ),
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              sendTo = newValue;
            });
          },
          selectedItem: sendTo,
        ),
      ],
    );
  }

  addEvent() async {
    final body = {
      'id': widget.isEdit ? widget.data!.id.toString() : null,
      'event_title': titleController.text,
      'for_whom': sendTo,
      'from_date': fromDateController.text,
      'to_date': toDateController.text,
      'event_des': descriptionController.text,
      'event_location': locationController.text,
    };
    log(body.toString());
    final response = await http.post(
        Uri.parse(widget.isEdit ? InfixApi.updateEvent() : InfixApi.addEvent()),
        body: jsonEncode(body),
        headers: Utils.setHeader(widget.token.toString()));
    print(response.statusCode);
    if (response.statusCode == 200) {
      _btnController.success();
      var msg = jsonDecode(response.body)['message'];
      Utils.showToast(msg);
      Navigator.pop(context);
    } else {
      _btnController.reset();
      var msg = jsonDecode(response.body)['message'];
      Utils.showToast(msg);
      throw Exception('Failed to load');
    }
  }
}
