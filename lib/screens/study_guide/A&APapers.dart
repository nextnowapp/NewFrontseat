import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextschool/utils/model/A&ApapersModel.dart';
import 'package:nextschool/utils/widget/download_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:recase/recase.dart';

class ANAPapersScreen extends StatefulWidget {
  ANAPapersScreen({Key? key}) : super(key: key);

  @override
  State<ANAPapersScreen> createState() => _ANAPapersScreenState();
}

class _ANAPapersScreenState extends State<ANAPapersScreen> {
  late List<DownloadController> _downloadControllers;
  late ANAList _anaPapers;
  String? directory;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _localPath().then((value) {
      setState(() {
        directory = value;
      });
      _loadBooksFromJsonAssets('English').then((List<ANAPapers> value) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Text(
            'ANA Exam Papers',
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
              isScrollable: true,
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
                Tab(
                  text: 'Sepedi',
                ),
                Tab(
                  text: 'Sesotho',
                ),
                Tab(
                  text: 'Setswana',
                ),
                Tab(
                  text: 'Siswati',
                ),
                Tab(
                  text: 'Xitsonga',
                ),
                Tab(
                  text: 'Isindebele',
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
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                           _downloadControllers = List<DownloadController>.generate(
                          snapshot.data!.length, (index) {
                        var url = snapshot.data![index].paperURL ?? '';
                        var fileName = url.split('/').last;
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
                            path: 'anaPapers',
                            url: snapshot.data![index].paperURL ?? '',
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
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
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].paperURL;
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
                                  path: 'anaPapers',
                                  url: snapshot.data![index].paperURL!,
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
                            ;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('Sepedi'),
                    builder:
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].paperURL;
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
                                  path: 'anaPapers',
                                  url: snapshot.data![index].paperURL!,
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
                            ;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('Sesotho'),
                    builder:
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].paperURL;
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
                                  path: 'anaPapers',
                                  url: snapshot.data![index].paperURL!,
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
                            ;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('Setswana'),
                    builder:
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].paperURL;
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
                                  path: 'anaPapers',
                                  url: snapshot.data![index].paperURL!,
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
                            ;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('Siswati'),
                    builder:
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].paperURL;
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
                                  path: 'anaPapers',
                                  url: snapshot.data![index].paperURL!,
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
                            ;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('Xitsonga'),
                    builder:
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].paperURL;
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
                                  path: 'anaPapers',
                                  url: snapshot.data![index].paperURL!,
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
                            ;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _loadBooksFromJsonAssets('Isindebele'),
                    builder:
                        (context, AsyncSnapshot<List<ANAPapers>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            _downloadControllers =
                                List<DownloadController>.generate(
                                    snapshot.data!.length, (index) {
                              var url = snapshot.data![index].paperURL;
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
                                  path: 'anaPapers',
                                  url: snapshot.data![index].paperURL!,
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
                            return BookCard(
                                book: book,
                                downloadController: downloadController);
                            ;
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

  Future<List<ANAPapers>> _loadBooksFromJsonAssets(String language) async {
    var jsonStr =
        await rootBundle.loadString('assets/ana_past_exam_papers.json');
    List jsonMap = json.decode(jsonStr);
    _anaPapers = ANAList.fromJson(jsonMap);
    var _filteredbooks;
    if (searchController.text == '') {
      _filteredbooks = _anaPapers.anaList
          .where((element) => element.language == language)
          .toList();
    } else {
      _filteredbooks = _anaPapers.anaList
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

    path = directory!.path + '/Nextschool/anaPapers';
    return path;
  }
}

class BookCard extends StatelessWidget {
  const BookCard({
    Key? key,
    required this.book,
    required this.downloadController,
  }) : super(key: key);

  final ANAPapers book;
  final DownloadController downloadController;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  Text(
                    book.subject!.titleCase,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Language: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: book.language!.titleCase,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
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
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: book.year.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
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
                              status: downloadController.downloadStatus,
                              downloadProgress: downloadController.progress,
                              onDownload: downloadController.startDownload,
                              onCancel: downloadController.stopDownload,
                              onOpen: downloadController.openDownload,
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
  }
}
