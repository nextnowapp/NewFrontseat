import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/school/wall_of_fame.dart';
import 'package:nextschool/utils/widget/txtbox.dart';
import 'package:sizer/sizer.dart';

import '../../controller/user_controller.dart';

class AddWallofFameScreen extends StatefulWidget {
  final bool isEdit;
  final WallOfFame? wallOfFame;
  const AddWallofFameScreen({
    Key? key,
    this.isEdit = false,
    this.wallOfFame,
  }) : super(key: key);

  @override
  State<AddWallofFameScreen> createState() => _AddWallofFameScreenState();
}

class _AddWallofFameScreenState extends State<AddWallofFameScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  var _image;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _designationController = TextEditingController();

  var _category;
  var _year;

  initState() {
    super.initState();
    if (widget.isEdit) {
      _nameController.text = widget.wallOfFame!.name;
      _descriptionController.text = widget.wallOfFame!.desc;
      _designationController.text = widget.wallOfFame!.designation;
      _category = widget.wallOfFame!.award_type;
      _year = widget.wallOfFame!.years;
      // _image = widget.wallOfFame!.imageUrl;
    }
  }

  ImageProvider imageProvider() {
    if (_image != null) {
      return FileImage(_image);
    } else {
      return const AssetImage('assets/images/principal.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.isEdit ? 'Edit Wall of Fame' : 'Add Wall of Fame',
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          //big image with edit button
          Stack(
            children: [
              (_image == null && (widget.isEdit == false))
                  ? Container(
                      height: 40.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: imageProvider(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : (_image == null && (widget.isEdit == true))
                      ? CachedNetworkImage(
                          imageUrl:
                              InfixApi().root + widget.wallOfFame!.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 40.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/principal.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/principal.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 40.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: imageProvider(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 30.sp,
                  width: 35.sp,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: HexColor('#3ab28d'),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () {
                      buildShowImagePickerModalBottomSheet(context);
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      size: 14.sp,
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          //form
          SizedBox(
            height: 2.h,
          ),
          Form(
              child: Column(
            children: [
              TxtField(
                hint: 'Student Name',
                controller: _nameController,
              ),
              SizedBox(
                height: 2.h,
              ),
              TxtField(
                hint: 'Description',
                controller: _descriptionController,
              ),
              SizedBox(
                height: 2.h,
              ),
              TxtField(
                hint: 'Designation',
                controller: _designationController,
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Expanded(child: getCategoryDropDown()),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(child: getYearDropDown()),
                ],
              ),
            ],
          )),
        ],

        //button to save
      ),
      bottomNavigationBar: Container(
        height: 10.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: ElevatedButton(
          onPressed: () {
            //do something when save button is pressed
            updateWallOfFame();
          },
          child: Text(
            'Save',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('#3ab28d'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoryDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
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
              return 'Please select a category';
            }
            return null;
          },
          // showSelectedItems: true,
          items: ['Normal', 'Sports', 'Arts'],

          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },

          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
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
                  item == 'Female'
                      ? Container()
                      : Divider(
                          color: HexColor('#8e9aa6'),
                          thickness: 0.5,
                        )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (2 * 42.sp) < 170.sp ? (2 * 42.sp) : 170.sp,
            ),
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
          onChanged: (dynamic newValue) {
            setState(() {
              _category = newValue;
              // genderId =
              //     _genders.singleWhere((e) => e['gender'] == newValue)['id'];
              // print(_genders.singleWhere((e) => e['gender'] == newValue)['id']);
              // debugPrint('User select $genderId');
            });
          },
          selectedItem: _category,
        ),
      ],
    );
  }

  Widget getYearDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Year',
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
              return 'Please select a year';
            }
            return null;
          },
          // showSelectedItems: true,
          items: List.generate(
              100, (index) => ((DateTime.now().year) - index).toString()),

          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },

          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
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
                  item == 'Female'
                      ? Container()
                      : Divider(
                          color: HexColor('#8e9aa6'),
                          thickness: 0.5,
                        )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (2 * 42.sp) < 170.sp ? (2 * 42.sp) : 170.sp,
            ),
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
          onChanged: (dynamic newValue) {
            setState(() {
              _year = newValue;
              // genderId =
              //     _genders.singleWhere((e) => e['gender'] == newValue)['id'];
              // print(_genders.singleWhere((e) => e['gender'] == newValue)['id']);
              // debugPrint('User select $genderId');
            });
          },
          selectedItem: _year,
        ),
      ],
    );
  }

  //function to fetch data to display
  Future<void> updateWallOfFame() async {
    //use dio to fetch data
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': _userDetailsController.token.toString()},
      contentType: 'application/json',
    ));

    var formData = FormData.fromMap({
      'id': widget.isEdit ? widget.wallOfFame!.id : null,
      'name': _nameController.text,
      'years': _year,
      'description': _descriptionController.text,
      'designation': _designationController.text,
      'image': _image != null
          ? await MultipartFile.fromFile(_image.path,
              filename: _image.path.split('/').last)
          : null,
      'award_type': _category,
      'school_id': 1,
    });

    //get response from api
    var response = await dio
        .post(
            widget.isEdit
                ? InfixApi.wallOfFameUpdate()
                : InfixApi.wallOfFameAdd(),
            data: formData)
        .catchError((e) {
      var msg = e.response.data['message'];
      Utils.showErrorToast(msg.toString());
    });

    //check if response is successful
    if (response.statusCode == 200) {
      var jsonData = response.data;
      var msg = jsonData['message'];
      Utils.showThemeToast(msg);
      Navigator.pop(context);
    } else {
      //if response is not successful
      throw Exception('Failed to load data');
    }
  }

  Future buildShowImagePickerModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        enableDrag: true,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 0.3 * MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Utils.sizedBoxHeight(24),
                const Text(
                  'Upload From!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        getImagefromGallery();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/gallery.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Utils.sizedBoxHeight(12),
                          const Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        getImagefromcamera();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/camera.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Utils.sizedBoxHeight(12),
                          const Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
          );
        });
  }

  Future getImagefromcamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future getImagefromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }
}
