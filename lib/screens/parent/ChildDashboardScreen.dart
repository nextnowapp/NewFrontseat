// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:nextschool/utils/CardItem.dart';
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/FunctionsData.dart';

// ignore: must_be_immutable
class ChildHome extends StatefulWidget {
  var _titles;
  var _images;
  dynamic id;
  String profileImage;
  String? token;
  String? name;

  ChildHome(this._titles, this._images, this.id, this.profileImage, this.token,
      this.name);

  @override
  _ChildHomeState createState() =>
      _ChildHomeState(_titles, _images, token, name);
}

class _ChildHomeState extends State<ChildHome> {
  bool? isTapped;
  dynamic currentSelectedIndex;
  var _titles;
  var _images;
  String? _token;
  String? _name;
  String? firstname;

  _ChildHomeState(this._titles, this._images, this._token, this._name);

  @override
  void initState() {
    super.initState();
    isTapped = false;
    firstname = _name!.split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "$firstname's Dashboard",
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: _titles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;
                });
              },
              element: AppFunction.getDashboardPage(context, _titles[index],
                  id: widget.id.toString(),
                  image: widget.profileImage,
                  token: _token),
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}

void navigateToPreviousPage(BuildContext context) {
  Navigator.pop(context);
}
