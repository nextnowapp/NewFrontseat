import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/school/add_edit_wall_of_fame.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/school/wall_of_fame.dart';
import 'package:sizer/sizer.dart';

class SchoolWallOfFame extends StatefulWidget {
  const SchoolWallOfFame({Key? key}) : super(key: key);

  @override
  State<SchoolWallOfFame> createState() => _SchoolWallOfFameState();
}

class _SchoolWallOfFameState extends State<SchoolWallOfFame> {
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  List<String> _categories = ['All'];
  List<String> _years =
      List.generate(100, (index) => ((DateTime.now().year) - index).toString());
  String? _selectedYear;

  List<WallOfFame> _wallOfFame = [];
  List<WallOfFame> _wallOfFameFiltered = [];

  initState() {
    super.initState();
    fetchWallOfFame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#eaeaea'),
      appBar: CustomAppBarWidget(
        title: 'School Wall of Fame',
      ),
      body: Column(
        children: [
          //Text : Meet the Winners
          Container(
            width: 100.w,
            padding:
                EdgeInsets.only(left: 5.w, top: 2.h, bottom: 3.h, right: 5.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meet the Winners',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: HexColor('#4f89ff'),
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                      ),
                    ),
                    Text(
                      'School Wall of Fame',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: HexColor('#151f3e'),
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                        ).fontFamily,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    //show selected category chips with cancel icon
                    Container(
                      height: 5.h,
                      width: (100.w - 100),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Container(
                          //   margin: EdgeInsets.only(right: 2.w),
                          //   child: InputChip(
                          //     isEnabled: true,
                          //     deleteIcon: const Icon(
                          //       CupertinoIcons.clear,
                          //       color: Colors.grey,
                          //       size: 16,
                          //     ),
                          //     onDeleted: () => {},
                          //     label: Text(
                          //       'Sports',
                          //       style: TextStyle(
                          //         fontSize: 9.sp,
                          //         fontFamily: GoogleFonts.inter(
                          //           fontWeight: FontWeight.w600,
                          //         ).fontFamily,
                          //       ),
                          //     ),
                          //     backgroundColor: HexColor('#e5eeff'),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          // ),
                          Visibility(
                            visible: _selectedYear != null,
                            child: Container(
                              margin: EdgeInsets.only(right: 2.w),
                              child: InputChip(
                                isEnabled: true,
                                deleteIcon: const Icon(
                                  CupertinoIcons.clear,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                onDeleted: () => {},
                                label: Text(
                                  _selectedYear.toString(),
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ).fontFamily,
                                  ),
                                ),
                                backgroundColor: HexColor('#e5eeff'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _selectedYear = await sortModalBottomSheet(context);
                        setState(() {
                          _selectedYear;
                        });
                        print(_selectedYear);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/Sort.svg',
                          height: 2.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Text(
                      'Sort',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: HexColor('#151f3e'),
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Cards with image, name, job title and passout year
          Expanded(
            child: FutureBuilder<WallOfFameList>(
                future: fetchWallOfFame(),
                builder: (context, AsyncSnapshot<WallOfFameList> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: _wallOfFameFiltered.length,
                      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: InfixApi().root +
                                          _wallOfFameFiltered[index].imageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.wallOfFame[index].name,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                            ).fontFamily,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data!.wallOfFame[index]
                                              .designation,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.black54,
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ).fontFamily,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _wallOfFameFiltered[index].years,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: HexColor('#4f89ff'),
                                            fontFamily: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                            ).fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _userDetailsController.roleId != 5
                                ? Container()
                                : Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      height: 30.sp,
                                      width: 30.sp,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: HexColor('#3ab28d'),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: IconButton(
                                        splashColor: Colors.transparent,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddWallofFameScreen(
                                                isEdit: true,
                                                wallOfFame: snapshot
                                                    .data!.wallOfFame[index],
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 14.sp,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: _userDetailsController.roleId != 5
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddWallofFameScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: HexColor('#3ab28d'),
            ),
    );
  }

  Future<String> sortModalBottomSheet(BuildContext context) async {
    String? _year;
    await custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      isDismissible: true,
      barrierColor: HexColor('#5b5c5f').withOpacity(0.5),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Material(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            height: 35.h,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Select Category',
                //   style: TextStyle(
                //     color: HexColor('#8e9aa6'),
                //     fontSize: 10.sp,
                //     fontFamily: GoogleFonts.inter(
                //       fontWeight: FontWeight.w600,
                //     ).fontFamily,
                //   ),
                // ),
                // //chip for selecting category
                // Wrap(
                //   spacing: 10,
                //   runSpacing: 10,
                //   children: [
                //     ..._categories.map(
                //       (e) => FilterChip(
                //         label: Text(
                //           e.toString(),
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 10.sp,
                //             fontFamily: GoogleFonts.inter(
                //               fontWeight: FontWeight.w600,
                //             ).fontFamily,
                //           ),
                //         ),
                //         side: BorderSide(
                //           color: HexColor('#4e88ff'),
                //         ),
                //         backgroundColor: Colors.white,
                //         selectedColor: HexColor('#4e88ff'),
                //         selected: true,
                //         showCheckmark: false,
                //         onSelected: (value) {},
                //       ),
                //     ),
                //   ],
                // ),

                // SizedBox(
                //   height: 3.h,
                // ),

                Text(
                  'Select Year',
                  style: TextStyle(
                    color: HexColor('#8e9aa6'),
                    fontSize: 10.sp,
                    fontFamily: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ).fontFamily,
                  ),
                ),
                //chip for selecting category
                Container(
                  height: 40,
                  width: 100.w,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: FilterChip(
                          label: Text(
                            'All',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: _year == null
                                  ? Colors.white
                                  : HexColor('#4e88ff'),
                              fontFamily: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ).fontFamily,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          selectedColor: HexColor('#4e88ff'),
                          side: BorderSide(
                            color: HexColor('#4e88ff'),
                          ),
                          selected: _year == null,
                          showCheckmark: false,
                          onSelected: (value) {
                            setState(() {
                              _year = null;
                            });
                          },
                        ),
                      ),
                      ..._years.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: FilterChip(
                            label: Text(
                              e,
                              style: TextStyle(
                                color: _year == e
                                    ? Colors.white
                                    : HexColor('#4e88ff'),
                                fontSize: 10.sp,
                                fontFamily: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ).fontFamily,
                              ),
                            ),
                            side: BorderSide(
                              color: HexColor('#4e88ff'),
                            ),
                            selected: _year == e,
                            backgroundColor: Colors.white,
                            selectedColor: HexColor('#4e88ff'),
                            showCheckmark: false,
                            onSelected: (value) {
                              setState(() {
                                _year = e;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //apply filter button
                Container(
                  margin: EdgeInsets.only(top: 3.h),
                  width: 100.w,
                  height: 5.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                        ).fontFamily,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#3ab28d'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );

    return _year!;
  }

  //function to fetch data to display
  Future<WallOfFameList> fetchWallOfFame() async {
    //use dio to fetch data
    Dio dio = Dio(BaseOptions(
      headers: {'Authorization': _userDetailsController.token.toString()},
      contentType: 'application/json',
    ));

    //get response from api
    var response = await dio.get(InfixApi.wallOfFameList()).catchError((e) {
      var msg = e.response.data['message'];
      Utils.showErrorToast(msg);
    });

    //check if response is successful
    if (response.statusCode == 200) {
      //convert response to json
      var data = response.data['data'];

      //return wall of fame list
      var a = WallOfFameList.fromJson(data);
      _wallOfFame = a.wallOfFame;
      _wallOfFameFiltered = _wallOfFame;
      if (_selectedYear != null) {
        _wallOfFameFiltered = _wallOfFame
            .where((element) => element.years.contains(_selectedYear!))
            .toList();
      }

      return a;
    } else {
      //if response is not successful
      throw Exception('Failed to load data');
    }
  }
}
