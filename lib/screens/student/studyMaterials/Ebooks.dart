import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextschool/screens/parent/ChildDashboardScreen.dart';
import 'package:nextschool/utils/model/ebook.dart';
import 'package:nextschool/utils/widget/download_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:recase/recase.dart';

class EbookScreen extends StatefulWidget {
  EbookScreen({Key? key}) : super(key: key);

  @override
  State<EbookScreen> createState() => _EbookScreenState();
}

class _EbookScreenState extends State<EbookScreen> {
  late List<DownloadController> _downloadControllers;
  late EbookList _ebooks;
  String? directory;

  final List<String> languages = [
    'Afrikaans',
    'English',
    'Isindebele',
    'Isixhosa',
    'Isizulu',
    'Sepedi',
    'Sesotho',
    'Setswana',
    'Siswati',
    'Tshivenda',
    'Xitsonga',
  ];

  List<Widget> _buildViewList() {
    return languages.map((language) {
      return FutureBuilder(
        future: _loadBooksFromJsonAssets(language.toLowerCase()),
        builder: (context, AsyncSnapshot<List<Ebooks>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                _downloadControllers = List<DownloadController>.generate(
                    snapshot.data!.length, (index) {
                  var url = snapshot.data![index].url;
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
                      path: 'ebooks',
                      url: snapshot.data![index].url,
                      downloadStatus: fileExists
                          ? DownloadStatus.downloaded
                          : DownloadStatus.notDownloaded,
                      onOpenDownload: () {
                        _openDownload(filePath);
                      });
                });
                final downloadController = _downloadControllers[index];
                final book = snapshot.data![index];
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
                              Text(
                                book.title.titleCase,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Grade: ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: (book.grade).toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                                text: book.language.titleCase,
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
                                                text: 'Size: ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              TextSpan(
                                                text: (book.size / 1024)
                                                        .toStringAsFixed(2) +
                                                    ' MB',
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
                                          status:
                                              downloadController.downloadStatus,
                                          downloadProgress:
                                              downloadController.progress,
                                          onDownload:
                                              downloadController.startDownload,
                                          onCancel:
                                              downloadController.stopDownload,
                                          onOpen:
                                              downloadController.openDownload,
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
      );
    }).toList();
  }

  @override
  void initState() {
    _localPath().then((value) {
      setState(() {
        directory = value;
      });
      _loadBooksFromJsonAssets('english').then((List<Ebooks> value) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: languages.length,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent),
          leading: IconButton(
            onPressed: (() {
              navigateToPreviousPage(context);
            }),
            icon: SvgPicture.asset(
              'assets/svg/angle.svg',
              color: Colors.black,
              height: ScreenUtil().setSp(18),
            ),
          ),
          title: Text(
            'Ebooks',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: ScreenUtil().setSp(20),
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: const Color(0xFF222744),
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            tabs: List.generate(
              languages.length,
              (index) => Tab(
                text: languages[index],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ..._buildViewList(),
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

  Future<List<Ebooks>> _loadBooksFromJsonAssets(String language) async {
    var jsonStr = await rootBundle.loadString('assets/books.json');
    List jsonMap = json.decode(jsonStr);
    _ebooks = EbookList.fromJson(jsonMap);
    var _filteredbooks = _ebooks.ebookList
        .where((element) => element.language == language)
        .toList();
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

    path = directory!.path + '/Nextschool/ebooks';
    return path;
  }
}
