import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nextschool/utils/widget/download_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:recase/recase.dart';

class NscPapersListScreen extends StatefulWidget {
  final String path;
  final dynamic map;
  NscPapersListScreen({Key? key, this.map, required this.path})
      : super(key: key);

  @override
  State<NscPapersListScreen> createState() => _NscPapersListScreenState();
}

class _NscPapersListScreenState extends State<NscPapersListScreen> {
  late List<DownloadController> _downloadControllers;
  String? directory;

  @override
  void initState() {
    _localPath().then((value) {
      setState(() {
        directory = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.map!.length,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Text(
            'NSC Papers',
            style: TextStyle(fontSize: 18),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: const Color(0xFF222744),
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            tabs: [
              ...List.generate(
                widget.map!.length,
                (index) => Tab(
                    text:
                        widget.map!.keys.elementAt(index).toString().titleCase),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ...List.generate(widget.map!.length, (index) {
              var list = widget.map!.values.elementAt(index);
              var dir = widget.map!.keys.elementAt(index);
              // var dir = '';
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final paper = list[index];
                  return Card(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/pdf.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: (paper['subject']
                                                .toString()
                                                .titleCase +
                                            ' '),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            paper['title'].toString().titleCase,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ...List.generate(
                                              paper['papers'].length, (index) {
                                            var name = paper['papers']
                                                .keys
                                                .elementAt(index) as String;
                                            return Expanded(
                                              child: Text(
                                                '${name.pascalCase}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          ...List.generate(
                                              paper['papers'].length, (index) {
                                            _downloadControllers = List<
                                                    DownloadController>.generate(
                                                paper['papers'].length,
                                                (index) {
                                              var url = paper['papers']
                                                  .values
                                                  .elementAt(index) as String;
                                              var fileName =
                                                  url.split('/').last;
                                              var filePath =
                                                  '$directory/$dir/$fileName';
                                              var fileExists;
                                              //check if file exists
                                              var file = File(filePath);
                                              if (file.existsSync()) {
                                                fileExists = true;
                                              } else {
                                                fileExists = false;
                                              }

                                              return SimulatedDownloadController(
                                                  path: '${widget.path}/$dir',
                                                  url: paper['papers']
                                                          .values
                                                          .elementAt(index)
                                                      as String,
                                                  downloadStatus: fileExists
                                                      ? DownloadStatus
                                                          .downloaded
                                                      : DownloadStatus
                                                          .notDownloaded,
                                                  onOpenDownload: () {
                                                    _openDownload(filePath);
                                                  });
                                            });
                                            final downloadController =
                                                _downloadControllers[index];
                                            return Expanded(
                                              child: SizedBox(
                                                width: 40,
                                                child: AnimatedBuilder(
                                                  animation: downloadController,
                                                  builder: (context, child) {
                                                    return DownloadButton(
                                                      status: downloadController
                                                          .downloadStatus,
                                                      downloadProgress:
                                                          downloadController
                                                              .progress,
                                                      onDownload:
                                                          downloadController
                                                              .startDownload,
                                                      onCancel:
                                                          downloadController
                                                              .stopDownload,
                                                      onOpen: downloadController
                                                          .openDownload,
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }

  void _openDownload(String path) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(
            path: path,
          ),
        ));
  }

  Future<String> _localPath() async {
    Directory? directory;
    String path;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    path = directory!.path + '/Nextschool/${widget.path}';
    return path;
  }
}
