import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:path_provider/path_provider.dart';

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;
  String? url;
  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required String url,
    required String path,
    required VoidCallback onOpenDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _url = url,
        _path = path,
        _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  String _url;
  String _path;
  late Dio dio;
  CancelToken? cancelToken;

  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _downloadFile();
    }
  }

  @override
  void stopDownload() async {
    if (_isDownloading) {
      _isDownloading = false;

      try {
        //close dio connection
        cancelToken!.cancel();
        dio.close(force: true);
      } catch (e) {
        print(e);
      }

      //remove the downloaded file
      var name = _url.split('/').last;
      var path;

      //get download directory for ios and android
      if (Platform.isIOS) {
        var directory = await getApplicationDocumentsDirectory();
        path = directory.path + '/Nextschool/$_path';
      } else {
        var directory = await (getExternalStorageDirectory());
        path = directory!.path + '/Nextschool/$_path';
      }

      //get the filename and check whether it exists, if so delete it
      var file = File(path + '/' + name);
      if (file.existsSync()) {
        print('Deleting file ' + file.path);
        try {
          await file.delete();
        } catch (e) {
          print(e);
        }
      }

      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _downloadFile() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    //Download the file from url using dio package
    //extract filename from url
    var name = _url.split('/').last;
    var path;

    //get download directory for ios and android
    if (Platform.isIOS) {
      var directory = await getApplicationDocumentsDirectory();
      path = directory.path + '/Nextschool/$_path';
    } else {
      var directory = await (getExternalStorageDirectory());
      path = directory!.path + '/Nextschool/$_path';
    }

    // check if file exists
    var file = File(path + '/' + name);
    if (file.existsSync()) {
      _downloadStatus = DownloadStatus.downloaded;
      notifyListeners();
      return;
    } else {
      _downloadStatus = DownloadStatus.downloading;
      notifyListeners();
      try {
        print('Downloading file from $_url');
        print('Downloading to $path');
        dio = new Dio();
        cancelToken = new CancelToken();
        await dio.download(
          _url,
          '$path/$name',
          cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
            _progress = received / total;
            print(
                'Downloading $name :  ${(_progress * 100).toStringAsFixed(0)}%');
            notifyListeners();
          },
        );
        if (_progress == 1.0) {
          _downloadStatus = DownloadStatus.downloaded;
          _isDownloading = false;
          notifyListeners();
        }
      } on DioException {
        if (cancelToken!.isCancelled) {
          Utils.showErrorToast('Download cancelled');
        } else {
          Utils.showErrorToast('Downloading failed');
        }
        _downloadStatus = DownloadStatus.notDownloaded;
        _isDownloading = false;
        notifyListeners();
      }
    }
  }
}

class DownloadButton extends StatelessWidget {
  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;
  const DownloadButton({
    Key? key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        // do nothing.
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.downloaded:
        onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            transitionDuration: transitionDuration,
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
            isFetching: _isFetching,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeGreen,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    Key? key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    var shape = ShapeDecoration(
      shape: const CircleBorder(),
      color: isDownloaded ? Colors.green : Colors.grey,
    );

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0),
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
            duration: transitionDuration,
            opacity: isDownloading || isFetching ? 0.0 : 1.0,
            curve: Curves.ease,
            child: Icon(
                isDownloaded
                    ? CupertinoIcons.eye
                    : CupertinoIcons.cloud_download,
                size: 22)),
      ),
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    Key? key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0),
            valueColor: AlwaysStoppedAnimation(isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeGreen),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}
