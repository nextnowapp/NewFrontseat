// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/screens/admin/Bloc/LeaveListBloc.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/model/LeaveAdmin.dart';
import 'package:nextschool/utils/widget/LeaveRowLayout.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

// ignore: must_be_immutable
class AdminLeavePage extends StatefulWidget {
  String url;
  String endPoint;
  bool? isStaff;

  AdminLeavePage(this.url, this.endPoint, {this.isStaff});

  @override
  _AdminLeavePageState createState() => _AdminLeavePageState();
}

class _AdminLeavePageState extends State<AdminLeavePage> {
  late StuffLeaveListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = StuffLeaveListBloc(context, widget.url, widget.endPoint);
    bloc.getStaffLeaveList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: StreamBuilder<LeaveAdminList?>(
        stream: bloc.getStaffLeaveSubject.stream,
        builder: (context, snap) {
          print(snap.data);
          if (snap.hasData) {
            if (snap.error != null) {
              return _buildErrorWidget(snap.error.toString());
            }
            if (snap.data!.leaves.length < 1) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utils.noDataImageWidgetWithText('No Leaves Found...!')
                ],
              ));
            }

            return Container(
              child: ListView.builder(
                itemCount: snap.data!.leaves.length,
                itemBuilder: (context, index) {
                  return LeaveRowLayout(snap.data!.leaves[index],
                      isStaff: widget.isStaff);
                },
              ),
            );
          } else if (snap.hasError) {
            return _buildErrorWidget(snap.error as String?);
          } else {
            return _buildLoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CustomLoader());
  }

  Widget _buildErrorWidget(String? error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error occured: $error'),
      ],
    ));
  }
}
