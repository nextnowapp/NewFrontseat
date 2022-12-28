import 'package:flutter/material.dart';

import '../../../../utils/CustomAppBarWidget.dart';

class AssignedSubjectScreen extends StatefulWidget {
  const AssignedSubjectScreen({Key? key}) : super(key: key);

  @override
  _AssignedSubjectScreenState createState() => _AssignedSubjectScreenState();
}

class _AssignedSubjectScreenState extends State<AssignedSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Assigned Learning Area',
      ),
      backgroundColor: Colors.white,
    );
  }
}
