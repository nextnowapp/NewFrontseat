import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextschool/screens/study_guide/widget/nsc_paper_type_wise.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:recase/recase.dart';

class NscPapersHomeScreen extends StatelessWidget {
  NscPapersHomeScreen({Key? key}) : super(key: key);

  dynamic map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'NSC Exam Past Papers'),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<dynamic>(
          future: _loadBooksFromJsonAssets(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              map = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // physics: const NeverScrollableScrollPhysics(),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 2,
                //   crossAxisSpacing: 8,
                //   mainAxisSpacing: 8,
                //   childAspectRatio: 0.8,
                // ),
                // shrinkWrap: true,
                children: [
                  ...List.generate(map!.length, (index) {
                    var mon = map!.values.elementAt(index);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...List.generate(
                          mon!.length,
                          (count) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 95,
                              width: MediaQuery.of(context).size.width,
                              child: YearCard(
                                month: mon!.keys.elementAt(count),
                                //set the keys as title
                                title: map!.keys.elementAt(index),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return NscPaperTypeWiseScreen(
                                          path:
                                              '${map!.keys.elementAt(index)}/${mon!.keys.elementAt(count)}',
                                          title: map!.keys.elementAt(index),
                                          map: mon!.values.elementAt(count),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> _loadBooksFromJsonAssets() async {
    var jsonStr = await rootBundle.loadString('assets/nsc_papers.json');
    dynamic jsonMap = json.decode(jsonStr);
    return jsonMap;
  }
}

class YearCard extends StatelessWidget {
  final String title;
  final String month;
  final VoidCallback? onTap;

  const YearCard({
    Key? key,
    required this.title,
    this.onTap,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: SvgPicture.asset('assets/svg/Papers Icon.svg'),
        title: Row(
          children: [
            Text(
              '${month.titleCase} , ',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: const Text(
          'Past Papers',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: const Color(0xfff2f2f2),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
