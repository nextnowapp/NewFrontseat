// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
// import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCheck {
  Future<void> checkPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> storagePermission =
        await [Permission.storage, Permission.manageExternalStorage].request();

    if (storagePermission[Permission.storage] != PermissionStatus.granted) {
      try {
        storagePermission = await [
          Permission.storage,
          Permission.manageExternalStorage
        ].request();
      } on Exception catch (e) {
        debugPrint('Error: $e');
      }
    } else {
      print('write permission ok');
    }
  }

  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: const Text('Permission denied'),
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: const Text(
                  'You must grant all permission to use this application',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
  }
}
