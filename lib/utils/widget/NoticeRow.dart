import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextschool/screens/student/notice/NoticeDetails.dart';
import 'package:nextschool/utils/model/Notice.dart';

import '../../config/app_config.dart';
import '../Utils.dart';
import '../apis/Apis.dart';

// ignore: must_be_immutable
class NoticRowLayout extends StatefulWidget {
  Notice notice;

  NoticRowLayout(this.notice);

  @override
  _NoticRowLayoutState createState() => _NoticRowLayoutState(notice);
}

class _NoticRowLayoutState extends State<NoticRowLayout> {
  Notice notice;

  _NoticRowLayoutState(this.notice);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoticDetailsLayout(notice)));
      },
      child: Container(
        height: 95,
        padding: const EdgeInsets.all(8),
        width: size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.height * 0.09,
                      child: CachedNetworkImage(
                        imageUrl: widget.notice.notice_image == null
                            ? AppConfig.defaultNoticeImageUrl
                            : InfixApi().root + widget.notice.notice_image!,
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(),
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                          imageUrl: AppConfig.defaultNoticeImageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  // Utils.sizedBoxHeight(10),
                  // Text(
                  //   Utils.parseHtmlString(widget.notice.title),
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  // Utils.sizedBoxHeight(10),
                  // Text(
                  //   Utils.parseHtmlString(widget.notice.destails),
                  //   maxLines: 3,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: const TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.grey),
                  // ),
                  // Utils.sizedBoxHeight(8),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     const Icon(
                  //       Icons.date_range,
                  //       size: 12,
                  //       color: Colors.blueGrey,
                  //     ),
                  //     Utils.sizedBoxWidth(4),
                  //     Text(
                  //       widget.notice.date != null && widget.notice.date != ''
                  //           ? Utils.dateFormatter(widget.notice.date!)
                  //           : '',
                  //       style: const TextStyle(
                  //           fontSize: 12, color: Colors.blueGrey),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.6,
                  child: Text(
                    Utils.parseHtmlString(widget.notice.title),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Text(
                    Utils.parseHtmlString(widget.notice.destails),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 12,
                      color: Colors.blueGrey,
                    ),
                    Utils.sizedBoxWidth(4),
                    Text(
                      widget.notice.date != null && widget.notice.date != ''
                          ? widget.notice.date!
                          : '',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
