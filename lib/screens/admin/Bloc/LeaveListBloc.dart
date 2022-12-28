// Package imports:
import 'package:flutter/cupertino.dart';
// Project imports:
import 'package:nextschool/screens/admin/Repository/StaffRepository.dart';
import 'package:nextschool/utils/model/LeaveAdmin.dart';
import 'package:rxdart/rxdart.dart';

class StuffLeaveListBloc {
  String url;
  String endPoint;
  BuildContext context;

  StuffLeaveListBloc(this.context, this.url, this.endPoint);

  final _repository = StaffRepository();

  final _subject = BehaviorSubject<LeaveAdminList>();

  getStaffLeaveList() async {
    LeaveAdminList? list =
        await _repository.getStaffLeave(context, url, endPoint);
    _subject.sink.add(list!);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<LeaveAdminList> get getStaffLeaveSubject => _subject;
}
