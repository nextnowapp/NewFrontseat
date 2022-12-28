import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextschool/screens/study_guide/widget/nsc_papers_list.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:recase/recase.dart';

class NscPaperTypeWiseScreen extends StatelessWidget {
  final String title;
  final dynamic map;
  final String path;
  const NscPaperTypeWiseScreen(
      {Key? key, this.map, required this.title, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: '${title.titleCase} NSC Papers'),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1),
          shrinkWrap: true,
          children: [
            ...List.generate(
              map!.length,
              (index) => MonthCard(
                fontSize: 20,
                //set the keys as title
                title: map!.keys.elementAt(index).toString().titleCase,
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return NscPapersListScreen(
                      path: '$path/' + map!.keys.elementAt(index),
                      map: map!.values.elementAt(index),
                    );
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthCard extends StatelessWidget {
  final String title;
  final double? fontSize;
  final VoidCallback? onTap;

  const MonthCard({
    Key? key,
    required this.title,
    this.onTap,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 10, left: 5, bottom: 10, top: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white30,
            width: 1,
          ),
          // color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 5,
              offset: const Offset(3, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white10,
            ],
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize ?? 22,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
