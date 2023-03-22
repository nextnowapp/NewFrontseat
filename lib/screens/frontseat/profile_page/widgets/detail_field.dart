import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/widget/textwidget.dart';

class DetailField extends StatelessWidget {
  DetailField(
      {Key? key, required this.title, required this.value, required this.icon})
      : super(key: key);
  String title;
  String value;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 35.w,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextWidget(
                  txt: value,
                  size: 15,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
