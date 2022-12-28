// Flutter imports:
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';

// Project imports:

class CustomWidget extends StatefulWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;
  final String headline;
  final String? icon;
  final Widget? element;

  const CustomWidget({
    Key? key,
    required this.index,
    required this.isSelected,
    required this.onSelect,
    required this.headline,
    required this.icon,
    required this.element,
  }) : super(key: key);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: OpenContainer(
          closedColor: Colors.white,
          closedElevation: 5,
          openColor: const Color(0xFF222744),
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          closedBuilder: (context, action) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SvgPicture.asset(
                    widget.icon.toString(),
                    height: 42.h,
                    width: 42.w,
                  ),
                  Text(
                    widget.headline != null ? widget.headline : '...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // color: widget.isSelected ? Colors.white : Colors.grey,
                      color: const Color.fromARGB(220, 16, 16, 16),
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w500,
                    ),
                    // maxLines: 1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          },
          openBuilder: (context, action) {
            if (widget.element != null) {
              return widget.element!;
            } else {
              return Scaffold(
                appBar: CustomAppBarWidget(
                  title: widget.headline,
                ),
                body: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                          'assets/lottie/upgrade animation.json'),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          "You've discovered yet another amazing feature by NextSchool.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'It will be available for FREE in our next update.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
    // : Card(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     elevation: 5,
    //     child: Container(
    //       decoration: BoxDecoration(
    //         shape: BoxShape.rectangle,
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(10.0),
    //       ),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: <Widget>[
    //           SvgPicture.asset(
    //             widget.icon.toString(),
    //             height: 42.h,
    //             width: 42.w,
    //           ),
    //           Text(
    //             widget.headline != null ? widget.headline : '...',
    //             maxLines: 2,
    //             overflow: TextOverflow.ellipsis,
    //             style: TextStyle(
    //               // color: widget.isSelected ? Colors.white : Colors.grey,
    //               color: const Color.fromARGB(220, 16, 16, 16),
    //               fontSize: ScreenUtil().setSp(12),
    //               fontWeight: FontWeight.w500,
    //             ),
    //             // maxLines: 1,
    //             textAlign: TextAlign.center,
    //           )
    //         ],
    //       ),
    //     ),
    //   );
  }
}
