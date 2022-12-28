// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Package imports:
import 'package:http/http.dart' as http;
import 'package:nextschool/controller/user_controller.dart';
// Project imports:
import 'package:nextschool/utils/CustomAppBarWidget.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/apis/Apis.dart';
import 'package:nextschool/utils/model/Book.dart';
import 'package:nextschool/utils/widget/BookRowLayout.dart';
import 'package:nextschool/utils/widget/customLoader.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookListScreen> {
  Future<BookList?>? books;
  String? _token;
  UserDetailsController _userDetailsController =
      Get.put(UserDetailsController());

  @override
  void initState() {
    super.initState();
    _token = _userDetailsController.token;
    books = getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Book List'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<BookList?>(
          future: books,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.books.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.books.length,
                  itemBuilder: (context, index) {
                    return BookListRow(snapshot.data!.books[index]);
                  },
                );
              } else {
                return Utils.noDataTextWidget();
              }
            } else {
              return const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CustomLoader(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<BookList?>? getAllBooks() async {
    final response = await http.get(Uri.parse(InfixApi.bookList),
        headers: Utils.setHeader(_token.toString()));

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      print(jsonData);
      return BookList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
    return null;
  }
}
