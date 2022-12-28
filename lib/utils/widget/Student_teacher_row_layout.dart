// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
// Project imports:
import 'package:nextschool/utils/model/Teacher.dart';
// Package imports:
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class StudentTeacherRowLayout extends StatefulWidget {
  Teacher teacher;
  int? per;

  StudentTeacherRowLayout(this.teacher, this.per);

  @override
  _StudentTeacherRowLayoutState createState() =>
      _StudentTeacherRowLayoutState();
}

class _StudentTeacherRowLayoutState extends State<StudentTeacherRowLayout> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: staffCard(),
    );

    // return Container(
    //   padding: EdgeInsets.all(8),
    //   width: size.width,
    //   decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.all(Radius.circular(12))),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       Container(
    //         height: 80,
    //         width: 80,
    //         child: CachedNetworkImage(
    //           imageUrl: widget.teacher.teacherImage == null
    //               ? 'public/uploads/staff/demo/staff.jpg'
    //               : InfixApi().root + widget.teacher.teacherImage,
    //           placeholder: (context, url) => CupertinoActivityIndicator(),
    //           errorWidget: (context, url, error) => CachedNetworkImage(
    //             imageUrl:
    //                 InfixApi().root + 'public/uploads/staff/demo/staff.jpg',
    //             imageBuilder: (context, imageProvider) => Container(
    //               height: 80,
    //               width: 80,
    //               decoration: BoxDecoration(
    //                 color: Colors.grey,
    //                 image: DecorationImage(
    //                   image: imageProvider,
    //                   fit: BoxFit.cover,
    //                 ),
    //                 borderRadius: BorderRadius.all(Radius.circular(16)),
    //               ),
    //             ),
    //             placeholder: (context, url) => CupertinoActivityIndicator(),
    //             errorWidget: (context, url, error) => Icon(Icons.error),
    //           ),
    //         ),
    //       ),
    //       Utils.sizedBoxWidth(16),
    //       Expanded(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.max,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(
    //               widget.teacher.teacherName,
    //               style: TextStyle(
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             Utils.sizedBoxHeight(8),
    //             InkWell(
    //               onTap: () async {
    //                 await canLaunch('mailto:${widget.teacher.teacherEmail}')
    //                     ? await launch('mailto:${widget.teacher.teacherEmail}')
    //                     : throw 'Could not launch ${widget.teacher.teacherEmail}';
    //               },
    //               child: Row(
    //                 children: [
    //                   Icon(
    //                     Icons.email,
    //                     size: 12,
    //                     color: Colors.blueGrey,
    //                   ),
    //                   Utils.sizedBoxWidth(8),
    //                   Text(
    //                     widget.teacher.teacherEmail,
    //                     style: TextStyle(
    //                         fontSize: 12,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.blueGrey),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Utils.sizedBoxHeight(8),
    //             InkWell(
    //               onTap: () async {
    //                 await canLaunch('tel:${widget.teacher.teacherPhone}')
    //                     ? await launch('tel:${widget.teacher.teacherPhone}')
    //                     : throw 'Could not launch ${widget.teacher.teacherPhone}';
    //               },
    //               child: Row(
    //                 children: [
    //                   Icon(
    //                     Icons.phone,
    //                     size: 12,
    //                     color: Colors.blueGrey,
    //                   ),
    //                   Utils.sizedBoxWidth(8),
    //                   Text(
    //                     widget.teacher.teacherPhone,
    //                     style: TextStyle(
    //                         fontSize: 12,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.blueGrey),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );

    // return Card(
    //   elevation: 5,
    //   child: ListTile(
    //     title: Padding(
    //       padding: const EdgeInsets.only(top: 8.0),
    //       child: Row(
    //         children: [
    //           SizedBox(
    //             height: 50,
    //             width: 50,
    //             child: CircleAvatar(
    //               child:
    //                    CachedNetworkImage(
    //                       imageUrl:
    //                           InfixApi().root + widget.teacher.teacherImage,
    //                       placeholder: (context, url) =>
    //                           CupertinoActivityIndicator(),
    //                       errorWidget: (context, url, error) =>
    //                           CachedNetworkImage(
    //                         imageUrl: InfixApi().root +
    //                             'public/uploads/staff/demo/staff.jpg',
    //                         imageBuilder: (context, imageProvider) => Container(
    //                           decoration: BoxDecoration(
    //                             image: DecorationImage(
    //                               image: imageProvider,
    //                               fit: BoxFit.cover,
    //                             ),
    //                             borderRadius:
    //                                 BorderRadius.all(Radius.circular(50)),
    //                           ),
    //                         ),
    //                         placeholder: (context, url) =>
    //                             CupertinoActivityIndicator(),
    //                         errorWidget: (context, url, error) =>
    //                             Icon(Icons.error),
    //                       ),
    //                     ),
    //             ),
    //           ),
    //           SizedBox(
    //             width: 10,
    //           ),
    //           Text(widget.teacher.teacherName,
    //               style: Theme.of(context).textTheme.headline4.copyWith(
    //                   fontSize: ScreenUtil().setSp(18.0),
    //                   fontWeight: FontWeight.w500)),
    //         ],
    //       ),
    //     ),
    //     subtitle: Padding(
    //       padding: const EdgeInsets.only(top: 8.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           InkWell(
    //             onTap: () async {
    //               await canLaunch('mailto:${widget.teacher.teacherEmail}')
    //                   ? await launch('mailto:${widget.teacher.teacherEmail}')
    //                   : throw 'Could not launch ${widget.teacher.teacherEmail}';
    //             },
    //             child: SizedBox(
    //               height: 30,
    //               child: Row(
    //                 children: [
    //                   Icon(
    //                     Icons.mail_outline,
    //                     color: Colors.indigo,
    //                     size: ScreenUtil().setSp(18.0),
    //                   ),
    //                   SizedBox(
    //                     width: 5,
    //                   ),
    //                   Text(widget.teacher.teacherEmail,
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .headline4
    //                           .copyWith(fontSize: ScreenUtil().setSp(14.0))),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           widget.teacher.teacherPhone == null ||
    //                   widget.teacher.teacherPhone == ''
    //               ? Container()
    //               : InkWell(
    //                   onTap: () async {
    //                     await canLaunch('tel:${widget.teacher.teacherPhone}')
    //                         ? await launch('tel:${widget.teacher.teacherPhone}')
    //                         : throw 'Could not launch ${widget.teacher.teacherPhone}';
    //                   },
    //                   child: SizedBox(
    //                     height: 30,
    //                     child: Row(
    //                       children: [
    //                         Icon(
    //                           Icons.phone,
    //                           color: Colors.indigo,
    //                           size: ScreenUtil().setSp(18.0),
    //                         ),
    //                         SizedBox(
    //                           width: 5,
    //                         ),
    //                         Text(
    //                             widget.per == 1
    //                                 ? widget.teacher.teacherPhone
    //                                 : 'not available',
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .headline4
    //                                 .copyWith(
    //                                     fontSize: ScreenUtil().setSp(14.0))),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    // return Column(
    //   children: <Widget>[
    //     Container(
    //       child: Row(
    //         children: <Widget>[
    //           Expanded(
    //             child: Text(teacher.teacherName,
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .headline4
    //                     .copyWith(fontSize: 10.0)),
    //           ),
    //           Expanded(
    //             child: Text(teacher.teacherEmail,
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .headline4
    //                     .copyWith(fontSize: 10.0)),
    //           ),
    //           Expanded(
    //             child: Text(per == 1 ? teacher.teacherPhone : 'not available',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .headline4
    //                     .copyWith(fontSize: 10.0)),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Container(
    //       height: 0.5,
    //       margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //             begin: Alignment.centerRight,
    //             end: Alignment.centerLeft,
    //             colors: [Colors.purple, Colors.deepPurple]),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget staffCard() => SizedBox(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                    flex: 8,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(2, 2),
                                color: Colors.black12,
                                blurRadius: 2),
                            BoxShadow(
                                offset: Offset(-2, -2),
                                color: Colors.black12,
                                blurRadius: 2),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.teacher.teacherName!,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Utils.sizedBoxHeight(6),
                          InkWell(
                            onTap: () async {
                              if (!await launch(
                                  'mailto:${widget.teacher.teacherEmail}'))
                                throw 'Couldnt launch ${widget.teacher.teacherEmail}';
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.teacher.teacherEmail!,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueGrey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Utils.sizedBoxHeight(6),
                          InkWell(
                            onTap: () async {
                              await canLaunch(
                                      'tel:${widget.teacher.teacherPhone}')
                                  ? await launch(
                                      'tel:${widget.teacher.teacherPhone}')
                                  : throw 'Could not launch ${widget.teacher.teacherPhone}';
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 12,
                                  color: Colors.blueGrey,
                                ),
                                Utils.sizedBoxWidth(4),
                                Text(
                                  widget.teacher.teacherPhone!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CachedNetworkImage(
                      imageUrl: widget.teacher.teacherImage == null
                          ? 'public/uploads/staff/demo/staff.jpg'
                          : InfixApi().root + widget.teacher.teacherImage!,
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        imageUrl: InfixApi().root +
                            'public/uploads/staff/demo/staff.jpg',
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          ),
                        ),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}
