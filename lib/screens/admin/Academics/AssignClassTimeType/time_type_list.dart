import 'package:flutter/material.dart';

import '../../../../utils/CustomAppBarWidget.dart';

class ClassTimeTypeList extends StatefulWidget {
  const ClassTimeTypeList({Key? key}) : super(key: key);

  @override
  _ClassTimeTypeListState createState() => _ClassTimeTypeListState();
}

class _ClassTimeTypeListState extends State<ClassTimeTypeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Time Type List',
      ),
      body: Container(),
    );
  }
}
