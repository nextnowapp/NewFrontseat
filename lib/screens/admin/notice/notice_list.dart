import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as custom_modal_bottom_sheet;
import 'package:nextschool/config/app_config.dart';
import 'package:nextschool/controller/user_controller.dart';
import 'package:nextschool/screens/admin/notice/AdminNoticeDetails.dart';
import 'package:nextschool/screens/admin/notice/add_notice.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
import 'package:nextschool/utils/widget/delete_bottomsheet.dart';
import 'package:nextschool/utils/widget/edit_bottomsheet.dart';
import 'package:nextschool/utils/widget/textwidget.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/apis/Apis.dart';
import 'AdminNoticeModel.dart';

class NoticeListScreen extends StatefulWidget {
  const NoticeListScreen({Key? key}) : super(key: key);

  @override
  _NoticeListScreenState createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  Future<AdminNoticeModel?>? notices;
  List<Datum>? noticeList = [];
  String? _token;

  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    _token = _userDetailsController.token;

    notices = getNotices();
    notices!.then((value) {
      setState(() {
        noticeList = value!.data;
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notices = getNotices();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Notice List',
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<AdminNoticeModel?>(
                future: notices,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: noticeList!.length,
                      itemBuilder: (context, index) {
                        var data = noticeList![index];
                        var firstData = noticeList!.firstWhere(
                            (element) => element.noticeDate == data.noticeDate);
                        return Column(
                          children: [
                            data.id == firstData.id
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.blueAccent),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                            child: TextWidget(
                                              txt: data.noticeDate ==
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(
                                                              DateTime.now())
                                                  ? 'Today'
                                                  : data.noticeDate ==
                                                          DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime
                                                                      .now()
                                                                  .subtract(
                                                                      const Duration(
                                                                          days:
                                                                              1)))
                                                      ? 'Yesterday'
                                                      : data.noticeDate!,
                                              clr: Colors.white,
                                              size: 10.sp,
                                            ),
                                          ),
                                        )),
                                  )
                                : const SizedBox(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdminNoticeDetails(
                                                snapshot.data!.data![index])));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        child: CachedNetworkImage(
                                          imageUrl: data.noticeImage == null
                                              ? AppConfig.defaultNoticeImageUrl
                                              : InfixApi().root +
                                                  data.noticeImage!,
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              CachedNetworkImage(
                                            imageUrl:
                                                AppConfig.defaultNoticeImageUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16)),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const CupertinoActivityIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Utils.sizedBoxWidth(16),
                                    Flexible(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            // (Utils.parseHtmlString(
                                            data.noticeTitle ?? '',
                                            // ))
                                            // .sentenceCase,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Utils.sizedBoxHeight(8),
                                          Text(
                                            (Utils.parseHtmlString(
                                                    data.noticeMessage ?? ''))
                                                .sentenceCase,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueGrey),
                                          ),
                                          Utils.sizedBoxHeight(8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.date_range,
                                                    size: 12,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  Utils.sizedBoxWidth(4),
                                                  Text(
                                                    data.noticeDate != null
                                                        ? data.noticeDate!
                                                        : '',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blueGrey),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      custom_modal_bottom_sheet
                                                          .showCupertinoModalBottomSheet(
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        100),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        100))),
                                                        isDismissible: false,
                                                        enableDrag: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return EditBottomSheet(
                                                              onEdit: () async {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return AddNoticeScreen(
                                                                  isEdit: true,
                                                                  data: data);
                                                            }));
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: const BoxDecoration(
                                                          color:
                                                              Color(0xFFF3F3F3),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: const Icon(
                                                        Icons.edit,
                                                        size: 14,
                                                        // color: Color(0xFFb0b2b8),
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        deleteNoticePromptDialog(
                                                            context,
                                                            data.id,
                                                            index);
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: const BoxDecoration(
                                                          color:
                                                              Color(0xFFF3F3F3),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 14,
                                                        // color: Color(0xFFb0b2b8),
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CustomLoader(),
                    );
                  }
                })),
      ),
    );
  }

  Future<AdminNoticeModel?>? getNotices() async {
    print('Started API Call');
    final response = await http.get(Uri.parse(InfixApi.getAdminNotice()),
        headers: Utils.setHeader(_token.toString()));
    log(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminNoticeModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }

  deleteNoticePromptDialog(BuildContext context, int? id, int index) async {
    return custom_modal_bottom_sheet.showCupertinoModalBottomSheet(
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
                Uri.parse(InfixApi.deleteNoticeData(id)),
                headers: Utils.setHeader(_token.toString()));
            if (response.statusCode == 200) {
              var jsonData = jsonDecode(response.body);
              Navigator.pop(context);
              Utils.showToast('Notice Deleted Successfully');
              setState(() {
                noticeList!.removeAt(index);
              });
            } else {
              throw Exception('Failed to load');
            }
          },
          title: 'Delete Notice',
        );
      },
    );
  }

  Widget slideRightBackground() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            const Text(
              ' Edit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            const Text(
              ' Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
