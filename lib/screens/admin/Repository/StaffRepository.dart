// Project imports:
import 'package:flutter/cupertino.dart';
import 'package:nextschool/screens/admin/ApiProvider/StaffApiProvider.dart';
import 'package:nextschool/utils/model/LeaveAdmin.dart';
import 'package:nextschool/utils/model/LibraryCategoryMember.dart';
import 'package:nextschool/utils/model/Staff.dart';

class StaffRepository {
  StaffApiProvider _provider = StaffApiProvider();

  Future<LibraryMemberList> getStaff() {
    return _provider.getAllCategory();
  }

  Future<StaffList> getStaffList(int? id) {
    return _provider.getAllStaff(id);
  }

  Future<LeaveAdminList?>? getStaffLeave(
      BuildContext context, String url, String endPoint) {
    return _provider.getAllLeave(context, url, endPoint);
  }
}
