import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SidebarItem extends StatefulWidget {
  final String title;
  final IconData icon;
  const SidebarItem({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  _SidebarItemState createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 8, top: 8),
      child: Row(
        children: [
          Icon(
            this.widget.icon,
            size: 20,
            color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              this.widget.title,
              style: TextStyle(
                  fontFamily:
                      GoogleFonts.inter(fontWeight: FontWeight.w400).fontFamily,
                  fontSize: 11.sp,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
