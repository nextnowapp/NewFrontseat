// Flutter imports:
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
// Project imports:
import 'package:nextschool/utils/model/Subject.dart';

// ignore: must_be_immutable
class SubjectRowLayout extends StatelessWidget {
  Subject subject;
  final index;
  SubjectRowLayout(this.subject, this.index);
  List colors = [
    HexColor('#e8faf7'),
    HexColor('#ffe6f9'),
    HexColor('#ecf8ff'),
    HexColor('#fdebe0')
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: const Offset(2, 2),
            blurRadius: 3,
            spreadRadius: 3,
          ), //BoxShadow
          //BoxShadow
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colors[index % colors.length],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      subject.subjectName!,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Text(
                    //   'Subject Code: ${snapshot.data!.subjects[index].subjectCode}',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // )
                  ],
                ),
              ),
              // SizedBox(
              //   width: MediaQuery.of(context)
              //           .size
              //           .width *
              //       0.2,
              // ),
              // Text(
              //     snapshot.data!.subjects[index]
              //         .subjectCode!,
              //     style: Theme.of(context)
              //         .textTheme
              //         .headline5),
              // Expanded(
              //   child: Text(subject.subjectType == 'T' ? 'Theory' : 'Lab',
              //       style: Theme.of(context).textTheme.headline5),
              // ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Educator',
              style: TextStyle(fontSize: 12, color: HexColor('#8b9cb3')),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              subject.teacherName!,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
      // padding: const EdgeInsets.all(8),
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.all(Radius.circular(12)),
      //   // border: Border.all(color: Color(0xFF222744),style: BorderStyle.solid),
      //   boxShadow: [
      //     BoxShadow(
      //         offset: Offset(0, 2), blurRadius: 2, color: Color(0x50222744))
      //   ],
      // ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      // Row(
      //   children: <Widget>[
      //     Container(
      //       height: 60,
      //       width: 60,

      //       // child: CachedNetworkImage(
      //       //   imageUrl: subject.teacherImage == null
      //       //       ? 'public/uploads/staff/demo/staff.jpg'
      //       //       : InfixApi().root + subject.teacherImage!,
      //       //   placeholder: (context, url) =>
      //       //       const CupertinoActivityIndicator(),
      //       //   errorWidget: (context, url, error) => CachedNetworkImage(
      //       //     imageUrl: InfixApi().root +
      //       //         'public/uploads/staff/demo/staff.jpg',
      //       //     imageBuilder: (context, imageProvider) => Container(
      //       //       height: 60,
      //       //       width: 60,
      //       //       decoration: BoxDecoration(
      //       //         color: Colors.grey,
      //       //         image: DecorationImage(
      //       //           image: imageProvider,
      //       //           fit: BoxFit.fitWidth,
      //       //         ),
      //       //         borderRadius:
      //       //             const BorderRadius.all(Radius.circular(32)),
      //       //       ),
      //       //     ),
      //       //     placeholder: (context, url) =>
      //       //         const CupertinoActivityIndicator(),
      //       //     errorWidget: (context, url, error) =>
      //       //         const Icon(Icons.error),
      //       //   ),
      //       // ),
      //     ),
      //     Utils.sizedBoxWidth(16),
      //     // Expanded(
      //     //   child: Row(
      //     //     children: [
      //     //       Expanded(
      //     //         flex: 4,
      //     //         child: Text(
      //     //           subject.teacherName!,
      //     //           maxLines: 2,
      //     //           overflow: TextOverflow.ellipsis,
      //     //           style: const TextStyle(
      //     //               fontSize: 22,
      //     //               color: Color(0xFF4E88FF),
      //     //               fontWeight: FontWeight.bold),
      //     //         ),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //     // Expanded(
      //     //   child: Text(subject.subjectType == 'T' ? 'Theory' : 'Lab',
      //     //       style: Theme.of(context).textTheme.headline6),
      //     // ),
      //   ],
      // ),
      // Row(
      //   children: [
      //     const Expanded(child: Divider()),
      //     const Text(
      //       'SUBJECT',
      //       style: TextStyle(
      //           // color: Color(0xFF222744),
      //           color: Colors.grey,
      //           fontSize: 12,
      //           fontWeight: FontWeight.bold),
      //     ),
      //     const Expanded(child: Divider()),
      //   ],
      // ),
      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Expanded(
      //       child: Text(
      //         subject.subjectName!,
      //         maxLines: 2,
      //         textAlign: TextAlign.center,
      //         overflow: TextOverflow.ellipsis,
      //         style: const TextStyle(
      //             // color: Colors.black,
      //             color: Color(0xFF222744),
      //             fontWeight: FontWeight.bold),
      //       ),
      //     ),
      //   ],
      // ),
      //   ],
      // ),
    );
  }
}
