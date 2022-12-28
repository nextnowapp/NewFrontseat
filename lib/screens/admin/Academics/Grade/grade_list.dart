import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/Academics/Grade/add_grade.dart';
import 'package:nextschool/utils/widget/edit_bottomsheet.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/widget/customLoader.dart';
import '../../../../utils/widget/delete_bottomsheet.dart';
import 'grade_model.dart';

class GradeList extends StatefulWidget {
  const GradeList({Key? key}) : super(key: key);

  @override
  _GradeListState createState() => _GradeListState();
}

class _GradeListState extends State<GradeList> {
  String? _token;
  Future<GradeModel?>? model;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());
  List colors1 = [
    const Color.fromARGB(252, 101, 217, 191),
    const Color.fromARGB(252, 245, 148, 164),
    const Color.fromARGB(252, 138, 171, 223),
    const Color.fromARGB(252, 206, 144, 230)
  ];
  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    model = fetchGradeList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Class List',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<GradeModel?>(
        future: model,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.data!.classes!.length == 0) {
              return Center(
                  child:
                      Utils.noDataImageWidgetWithText('No Grade List Found'));
            } else {
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Utils.sizedBoxHeight(16);
                  },
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.data!.classes!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.data!.classes![index];
                    // List<String>? classs = data.assignedSectionsName;
                    // final abcList = data.assignedSectionsName;
                    return Card(
                      elevation: 4,
                      child: Container(
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: , vertical: 8),
                        width: size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: ListTile(
                          leading: Wrap(
                            children: [
                              const Text(
                                'Class: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Text(
                                data.className!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          title: SizedBox(
                            width: 100,
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: List.generate(
                                  data.assignedSectionsName?.length ?? 0,
                                  (index) => Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: colors1[index],
                                          child: Text(
                                            data.assignedSectionsName?[index] ??
                                                '',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                            ),
                          ),
                          trailing: PopupMenuButton<int>(
                            icon: const Icon(
                              Icons.more_vert,
                              size: 20,
                              color: Colors.black,
                            ),
                            itemBuilder: (context) => [
                              // popupmenu item 1
                              PopupMenuItem(
                                value: 1,
                                // row has two child icon and text.
                                child: InkWell(
                                  onTap: () {
                                    editNoticePromptDialog(context, data);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 28,
                                        width: 28,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFF3F3F3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 14,
                                          // color: Color(0xFFb0b2b8),
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Edit',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // popupmenu item 2
                              PopupMenuItem(
                                value: 2,
                                // row has two child icon and text
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      deleteNoticePromptDialog(
                                          context, data.id);
                                      (context as Element).reassemble();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 28,
                                        width: 28,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFF3F3F3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 14,
                                          // color: Color(0xFFb0b2b8),
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            // offset: Offset(0, 100),
                            color: Colors.white,
                            elevation: 1,
                          ),
                        ),
                      ),
                    );
                  });
            }
          } else
            return const Center(
              child: CustomLoader(),
            );
        },
      ),
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AddGrade(
      //             isEdit: false,
      //           ),
      //         ));
      //   },
      //   child: Align(
      //     alignment: Alignment.bottomRight,
      //     child: Container(
      //       height: 50,
      //       width: 180.0,
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(30),
      //           color: const Color.fromARGB(252, 77, 136, 254)),
      //       child: SizedBox(
      //         width: 200,
      //         child: Row(
      //           children: [
      //             const SizedBox(width: 20),
      //             SvgPicture.asset('assets/images/Add Grade Icon.svg'),
      //             const SizedBox(
      //               width: 20,
      //             ),
      //             const Text(
      //               'Add Class',
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 16),
      //             ),
      //           ],
      //         ),
      //       ),
      //       // shape: RoundedRectangleBorder(
      //       //   borderRadius: BorderRadius.circular(10.0),
      //       // ),
      //     ),
      //   ),
      // ),
    );
  }

  Future<GradeModel?>? fetchGradeList() async {
    final response = await http.get(Uri.parse(InfixApi.classList()),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return GradeModel.fromJson(jsonData);
    } else {
      throw Exception('failed to load');
    }
    return null;
  }

  editNoticePromptDialog(BuildContext context, Class list) async {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return EditBottomSheet(onEdit: () async {
          Utils.showProcessingToast();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddGrade(
                        isEdit: true,
                        model: list,
                      )));
        });
      },
    );
  }

  deleteNoticePromptDialog(BuildContext context, int? id) {
    custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(100), topLeft: Radius.circular(100))),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return DeleteBottomSheet(
          onDelete: () async {
            Utils.showProcessingToast();
            final response = await http.get(
                Uri.parse(InfixApi.deleteGrade(id.toString())),
                headers: Utils.setHeader(_token.toString()));
            if (response.statusCode == 200) {
              setState(() {
                var jsonData = jsonDecode(response.body);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GradeList()));
                // Utils.showSnackBar(context, 'Grade Deleted Successfully',
                //     color: Colors.green);
                Utils.showToast('Grade Deleted Successfully');
              });
            } else {
              throw Exception('Failed to load');
            }
          },
          title: 'Delete Class',
        );
        setState(() {});
      },
    );
  }
}
