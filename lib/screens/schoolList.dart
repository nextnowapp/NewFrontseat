import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nextschool/utils/model/School.dart';

class SchoolListScreen extends StatefulWidget {
  final String? userRole;
  const SchoolListScreen({Key? key, this.userRole}) : super(key: key);

  @override
  _SchoolListScreenState createState() => _SchoolListScreenState();
}

class _SchoolListScreenState extends State<SchoolListScreen> {
  bool _searchClicked = false;
  List<String?> _searchList = [];
  SchoolList? sList;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        backgroundColor: const Color(0xFF222744),
        title: Column(
          children: [
            _searchClicked
                ? TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    cursorColor: Colors.white,
                    cursorHeight: 16,
                    cursorWidth: 0.7,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search Schools by name',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  )
                : const Text(
                    'Schools',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchClicked = !_searchClicked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: _searchClicked && _searchController.text.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      findSpecificUser(_searchController.text),
                      (index) => ListTile(
                        title: Text(
                          _searchList[index]!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          var query = _searchList[index];
                          sList!.schools.forEach((element) {
                            if (element.name!
                                .toLowerCase()
                                .contains(query!.toLowerCase())) {
                              _sendDataBack(context, element);
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            : FutureBuilder<SchoolList?>(
                // future: Utils.getStringValue('fullname'),
                future: getSchoolList(),
                builder: (BuildContext context,
                    AsyncSnapshot<SchoolList?> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.schools.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                snapshot.data!.schools[index].name!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _sendDataBack(
                                    context, snapshot.data!.schools[index]);
                              },
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    );
                  }

                  return Container();
                },
              ),
      ),
    );
  }

  Future<SchoolList?> getSchoolList() async {
    //fetch all schools lists from firebase colleciton
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('school').get();
    print('Inside getschool list');
    var docs = querySnapshot.docs.map((doc) => doc.data());
    sList = SchoolList.fromJson(docs.toList());
    // return SchoolList.fromJson(docs);
    return sList;
  }

  void _sendDataBack(BuildContext context, School school) {
    Navigator.pop(context, school);
  }

  int findSpecificUser(String query) {
    // ChatUserList _queryList = _chatUserList;
    _searchList.clear();
    sList!.schools.forEach((element) {
      if (element.name!.toLowerCase().contains(query.toLowerCase())) {
        print('matched');
        _searchList.add(element.name);
      }
    });
    return _searchList == null ? 0 : _searchList.length;
  }
}
