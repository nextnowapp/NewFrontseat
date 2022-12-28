// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/screens/admin/Bloc/StaffBloc.dart';
import 'package:nextschool/screens/admin/staff/AddStaffScreen.dart';
import 'package:nextschool/utils/CardItem.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/model/LibraryCategoryMember.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

import 'StaffListScreen.dart';

class AdminStaffList extends StatefulWidget {
  var _titles;
  var _images;

  AdminStaffList(this._titles, this._images);

  @override
  _AdminStaffListState createState() => _AdminStaffListState(_titles, _images);
}

class _AdminStaffListState extends State<AdminStaffList> {
  var _titles;
  var _images;
  int? currentSelectedIndex;
  _AdminStaffListState(this._titles, this._images);
  @override
  void initState() {
    super.initState();
    bloc.getStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF222744),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: 'Staff',
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<LibraryMemberList>(
              stream: bloc.subject.stream,
              builder: (context, catSnap) {
                if (catSnap.hasData) {
                  if (catSnap.error != null) {
                    return _buildErrorWidget(catSnap.error.toString());
                  }
                  return _buildStaffWidget(catSnap.data);
                } else if (catSnap.hasError) {
                  return _buildErrorWidget(catSnap.error as String?);
                } else {
                  return _buildLoadingWidget();
                }
              },
            ),
          ),
        ));
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CustomLoader());
  }

  Widget _buildErrorWidget(String? error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error occurred: $error'),
      ],
    ));
  }

  Widget _buildStaffWidget(LibraryMemberList? data) {
    return Container(
      child: GridView.builder(
        itemCount: _titles.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return CustomWidget(
            index: index,
            isSelected: currentSelectedIndex == index,
            onSelect: () {
              setState(() {
                currentSelectedIndex = index;
                // AppFunction.getAdminFeePage(context, _titles[index]);
              });
            },
            element: getWidget(_titles[index], data!.members[index].id),
            headline: _titles[index],
            icon: _images[index],
          );
        },
      ),
    );
  }

  Widget? getWidget(String? title, id) {
    switch (title) {
      case 'Add Staff':
        {
          return AddStaffScreen();
        }
        break;
      case 'Staff List':
        {
          return StaffListScreen(id);
        }
    }
    return null;
  }
}
