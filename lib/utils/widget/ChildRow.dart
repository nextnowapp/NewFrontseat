// Flutter imports:
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
// Project imports:
import 'package:nextschool/screens/parent/ChildDashboardScreen.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Child.dart';
import 'package:recase/recase.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ChildRow extends StatefulWidget {
  Child child;
  String? token;

  ChildRow(this.child, this.token);

  @override
  _ChildRowState createState() => _ChildRowState(child, token);
}

class _ChildRowState extends State<ChildRow> {
  Child child;
  String? token;

  _ChildRowState(this.child, this.token);

  @override
  Widget build(BuildContext context) {
    String image = child.photo == null || child.photo == ''
        ? 'http://saskolhmg.com/images/studentprofile.png'
        : InfixApi().root + child.photo!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 2.sp),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                        image: DecorationImage(
                          image: NetworkImage(image),
                        )),
                  ),
                  Utils.sizedBoxWidth(15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (child.name!).toLowerCase().titleCase,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                        ),
                        Utils.sizedBoxHeight(10),
                        Visibility(
                          visible: child.age != null,
                          child: Text(
                            child.age == null ? '' : 'Age: ' + child.age!,
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                child.school_name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Utils.sizedBoxHeight(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Class',
                                  style: TextStyle(
                                      color: HexColor('#151f3e'),
                                      fontWeight: FontWeight.w500),
                                ),
                                Utils.sizedBoxWidth(10),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.black,
                                ),
                                Utils.sizedBoxWidth(10),
                                Text(
                                  child.className ?? '',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: HexColor('#151f3e'),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Roll No.',
                                  style: TextStyle(
                                      color: HexColor('#151f3e'),
                                      fontWeight: FontWeight.w500),
                                ),
                                Utils.sizedBoxWidth(10),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.black,
                                ),
                                Utils.sizedBoxWidth(10),
                                Text(
                                  child.roll.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: HexColor('#151f3e'),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Utils.sizedBoxHeight(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 5.h,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(
                      color: HexColor('#4ac19e'),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                        ),
                        const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => ChildHome(
                                AppFunction.students,
                                AppFunction.studentIcons,
                                child.id,
                                image,
                                token,
                                child.name));
                        Navigator.pushReplacement(context, route);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'View Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 15.sp,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
