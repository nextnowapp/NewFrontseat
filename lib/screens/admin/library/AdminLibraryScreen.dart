// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/CardItem.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';

// ignore: must_be_immutable
class AdminLibraryHome extends StatefulWidget {
  var _titles;
  var _images;
  int? id;
  String? profileImage;

  AdminLibraryHome(this._titles, this._images);

  @override
  _AdminLibraryHomeState createState() =>
      _AdminLibraryHomeState(_titles, _images);
}

class _AdminLibraryHomeState extends State<AdminLibraryHome> {
  bool? isTapped;
  int? currentSelectedIndex;
  var _titles;
  var _images;

  _AdminLibraryHomeState(this._titles, this._images);

  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF222744),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: CustomAppBarWidget(
            title: 'Digital Library',
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    });
                  },
                  element:
                      AppFunction.getAdminLibraryPage(context, _titles[index]),
                  headline: _titles[index],
                  icon: _images[index],
                );
              },
            ),
          ),
        ));
  }
}
