// Dart imports:

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Timeline.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

// ignore: must_be_immutable
class TimeLineView extends StatelessWidget {
  var progress = '';
  Timeline timeline;

  TimeLineView(this.timeline);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 14,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 0.5,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.rectangle,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                timeline.title!,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                timeline.date!,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: const Color(0xff415094),
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                timeline.description!,
                maxLines: 5,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: const Color(0xff415094),
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              timeline.file != '' && timeline.file != null
                  ? ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        showDownloadAlertDialog(context);
                      },
                      // leading: Icon(Icons.file_present),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.file_present,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            'Download',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  showDownloadAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text('View'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (timeline.file!.contains('.pdf')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfView(
                path:  InfixApi().root + timeline.file!,
              ),
            ),
          );
        } else if (timeline.file!.contains('.jpg') ||
            timeline.file!.contains('.png') ||
            timeline.file!.contains('.jpeg')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Utils.fullScreenImageView(
                 InfixApi().root + timeline.file!,
              ),
            ),
          );
        } else {
          Utils.showToast(
              'File type not supported by this app. Please use supported file viewer app.');
        }
      },
    );
    Widget yesButton = TextButton(
      child: const Text('Download'),
      onPressed: () {
        timeline.file != null && timeline.file != ''
            ? downloadFile(timeline.file!)
            : Utils.showToast('no file found');
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Download',
        style: Theme.of(context).textTheme.headline5,
      ),
      content: const Text('Would you like to download the file?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();

    String dirloc = '';
    dirloc = (await getApplicationDocumentsDirectory()).path;

    try {
      FileUtils.mkdir([dirloc]);
      Utils.showToast('Downloading...');
      await dio.download(
          InfixApi().root + url, dirloc + AppFunction.getExtention(url),
          onReceiveProgress: (receivedBytes, totalBytes) {
        progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + '%';
      });
    } catch (e) {
      print(e);
    }
    Utils.showToast(
        'Download Completed.Go to the download folder to find the file');
    progress = 'Download Completed.Go to the download folder to find the file';
  }
}
