import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nextschool/screens/study_guide/exam_guidelines.dart';
import 'package:nextschool/screens/study_guide/ieb_paper.dart';
import 'package:nextschool/screens/study_guide/mind_the_gap.dart';
import 'package:nextschool/screens/study_guide/nsc_papers_home.dart';

class StudyGuideHomeScreen extends StatefulWidget {
  const StudyGuideHomeScreen({Key? key}) : super(key: key);

  @override
  State<StudyGuideHomeScreen> createState() => _StudyGuideHomeScreenState();
}

class _StudyGuideHomeScreenState extends State<StudyGuideHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Explore Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('See all',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75),
              shrinkWrap: true,
              children: [
                StudyGuideCategoryIcon(
                  count: 10,
                  title: 'Mind the Gap',
                  image: 'assets/svg/Mind the Gap.svg',
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return Grade12EBooks();
                    }));
                  },
                ),
                StudyGuideCategoryIcon(
                  count: 12,
                  title: 'Exam Guide',
                  image: 'assets/svg/Exam Guidelines.svg',
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return ExamGuidelinesScreen();
                    }));
                  },
                ),
                StudyGuideCategoryIcon(
                  count: 12,
                  title: 'NSC Exam Past Papers',
                  image: 'assets/svg/NSC Papers.svg',
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return NscPapersHomeScreen();
                    }));
                  },
                ),
                StudyGuideCategoryIcon(
                  count: 12,
                  title: 'IEB Exam Past Papers',
                  image: 'assets/svg/IEB Papers.svg',
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return IEBPapersScreen();
                    }));
                  },
                ),
               
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StudyGuideCategoryIcon extends StatelessWidget {
  final String title;
  final String image;
  final int count;
  final VoidCallback? onTap;

  const StudyGuideCategoryIcon({
    Key? key,
    required this.title,
    required this.image,
    required this.count,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  image,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$count Pdfs',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
