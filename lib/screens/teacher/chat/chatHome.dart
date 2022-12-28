import 'package:flutter/material.dart';

import '../../../utils/CardItem.dart';
import '../../../utils/CustomAppBarWidget.dart';
import '../../../utils/FunctionsData.dart';

class ChatHome extends StatefulWidget {
  var _titles;
  var _images;
  var id;

  ChatHome(this._titles, this._images, {this.id});

  @override
  _ChatHomeState createState() =>
      _ChatHomeState(_titles, _images, sId: id);
}

class _ChatHomeState extends State<ChatHome> {
  bool? isTapped;
  int? currentSelectedIndex;
  var _titles;
  var _images;
  var sId;

  _ChatHomeState(this._titles, this._images, {this.sId});

  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Chat'),
      backgroundColor: Colors.white,
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
              element: AppFunction.getChatDashboardPage(
                  context, _titles[index],),
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}
