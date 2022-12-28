import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextschool/utils/widget/download_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:recase/recase.dart';

import '../../utils/model/IebPapersModel.dart';

class IEBPapersScreen extends StatefulWidget {
  IEBPapersScreen({Key? key}) : super(key: key);

  @override
  State<IEBPapersScreen> createState() => _IEBPapersScreenState();
}

class _IEBPapersScreenState extends State<IEBPapersScreen> {
  late List<DownloadController> _downloadControllers;
  late IEBList _IEBPapers;
  String? directory;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _localPath().then((value) {
      setState(() {
        directory = value;
      });
      _loadBooksFromJsonAssets('English').then((List<IEBPapers> value) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Text(
            'IEB Exam Papers',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                placeholder: 'Search Subjects',
                controller: searchController,
                backgroundColor: Colors.white,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const TabBar(
              isScrollable: false,
              labelColor: Color(0xFF222744),
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              // physics: NeverScrollableScrollPhysics(),
              tabs: [
                Tab(
                  text: 'English',
                ),
                Tab(
                  text: 'Afrikaans',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('English'),
                    builder:
                        (context, AsyncSnapshot<List<IEBPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].materialURL;
                              var fileName = url!.split('/').last;
                              var filePath = '$directory/$fileName';
                              var fileExists;
                              //check if file exists
                              var file = File(filePath);
                              if (file.existsSync()) {
                                fileExists = true;
                              } else {
                                fileExists = false;
                              }

                              return SimulatedDownloadController(
                                  path: 'iebPapers',
                                  url: snapshot.data![index].materialURL!,
                                  downloadStatus: fileExists
                                      ? DownloadStatus.downloaded
                                      : DownloadStatus.notDownloaded,
                                  onOpenDownload: () {
                                    _openDownload(filePath);
                                  });
                            });
                            final downloadController =
                                _downloadControllers[index];
                            final book = snapshot.data![index];
                            return Card(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.subject!.titleCase,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Language: ',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: book.language!
                                                                .titleCase,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Year: ',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: book.year
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
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
                                            ],
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
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('Afrikaans'),
                    builder:
                        (context, AsyncSnapshot<List<IEBPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].materialURL;
                              var fileName = url!.split('/').last;
                              var filePath = '$directory/$fileName';
                              var fileExists;
                              //check if file exists
                              var file = File(filePath);
                              if (file.existsSync()) {
                                fileExists = true;
                              } else {
                                fileExists = false;
                              }

                              return SimulatedDownloadController(
                                  path: 'iebPapers',
                                  url: snapshot.data![index].materialURL!,
                                  downloadStatus: fileExists
                                      ? DownloadStatus.downloaded
                                      : DownloadStatus.notDownloaded,
                                  onOpenDownload: () {
                                    _openDownload(filePath);
                                  });
                            });
                            final book = snapshot.data![index];
                            final downloadController =
                                _downloadControllers[index];
                            return Card(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.subject!.titleCase,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Language: ',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: book.language!
                                                                .titleCase,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Year: ',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: book.year
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
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
                                            ],
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
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDownload(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfView(path: path),
      ),
    );
  }

  Future<List<IEBPapers>> _loadBooksFromJsonAssets(String language) async {
    var jsonStr =
        await rootBundle.loadString('assets/ieb-past-exam-papers.json');
    List jsonMap = json.decode(jsonStr);
    _IEBPapers = IEBList.fromJson(jsonMap);
    var _filteredbooks;
    if (searchController.text == '') {
      _filteredbooks = _IEBPapers.iebList
          .where((element) => element.language == language)
          .toList();
    } else {
      _filteredbooks = _IEBPapers.iebList
          .where((element) =>
              element.language == language &&
              element.subject!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
          .toList();
    }
    return _filteredbooks;
  }

  Future<String> _localPath() async {
    Directory? directory;
    String path;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    path = directory!.path + '/Nextschool/iebPapers';
    return path;
  }
}
