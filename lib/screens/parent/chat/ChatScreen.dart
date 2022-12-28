import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  Color whatsAppGreen = const Color.fromRGBO(18, 140, 126, 1.0);
  Color whatsAppGreenLight = const Color.fromRGBO(37, 211, 102, 1.0);
  Color statusbarColor = const Color(0xFF222744);
  TabController? tabController;
  var fabIcon = Icons.message;

  Map<String, dynamic>? _userMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Future<String> getUserRole() async {
    //   var role = await FirebaseAuth.instance.currentUser!
    //       .getIdTokenResult()
    //       .then((value) => value.claims!['role']);
    //   return role;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/lottie/upgrade animation.json',
            ),
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
      // body: Container(
      //   child: StreamBuilder<QuerySnapshot>(
      //     // future: Utils.getStringValue('fullname'),
      //     stream: fetchAllUser(),
      //     builder: (BuildContext context, snapshot) {
      //       if (snapshot.hasData) {
      //         return ListView.builder(
      //           itemCount: snapshot.data.docs.length,
      //           itemBuilder: (context, index) {
      //             return Column(
      //               children: <Widget>[
      //                 ListTile(
      //                   leading: CircleAvatar(
      //                     backgroundImage: NetworkImage(
      //                         snapshot.data.docs[index]["profile"]),
      //                   ),
      //                   title: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Row(
      //                         mainAxisAlignment:
      //                             MainAxisAlignment.spaceBetween,
      //                         children: <Widget>[
      //                           //Getting the name of the user
      //                           Text(
      //                             snapshot.data.docs[index]["name"],
      //                             style: TextStyle(
      //                               color: Colors.black,
      //                               fontWeight: FontWeight.w600,
      //                               fontSize: 14,
      //                             ),
      //                           ),
      //                           /*Text(
      //                               "Name",
      //                               style: TextStyle(
      //                                   color: Colors.black,
      //                                   fontWeight: FontWeight.w500,
      //                                   fontSize: 18.0),
      //                             ),*/
      //                           Text(
      //                             snapshot.data.docs[index]["status"],
      //                             //time here
      //                             style: TextStyle(
      //                                 color: Colors.black45, fontSize: 10),
      //                           ),
      //                         ],
      //                       ),
      //                       SizedBox(
      //                         height: 5,
      //                       ),
      //                       Text(
      //                         snapshot.data.docs[index]["role"],
      //                         style: TextStyle(
      //                             color: Colors.black45, fontSize: 12.0),
      //                       ),
      //                     ],
      //                   ),
      //                   subtitle: Padding(
      //                     padding: const EdgeInsets.only(top: 0.0),
      //                     child: Text(
      //                       "",
      //                       style: TextStyle(
      //                           color: Colors.black45, fontSize: 10.0),
      //                     ),
      //                   ),
      //                   onTap: () {
      //                     var partnerUID = snapshot.data.docs[index]["uid"];
      //                     _userMap = snapshot.data.docs[index].data();
      //                     print("userMap $_userMap");
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => conversationScreen(
      //                           chatRoomId: _getChatRoomId(partnerUID,
      //                               FirebaseAuth.instance.currentUser.uid),
      //                           userMap: _userMap,
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //                 Divider(),
      //               ],
      //             );
      //           },
      //         );
      //       }
      //
      //       return Container();
      //     },
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () async {
      //       //add left slide animation to navigation router
      //       var userRole = await FirebaseAuth.instance.currentUser
      //           .getIdTokenResult()
      //           .then((value) => value.claims['role']);
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => UserList(userRole: userRole),
      //         ),
      //       );
      //     },
      //     child: Icon(
      //       Icons.message,
      //       size: 20,
      //     ),
      //     backgroundColor: Color(0xFF222744)),
    );
  }

  // String _getChatRoomId(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return '$b\_$a';
  //   } else {
  //     return '$a\_$b';
  //   }
  // }

  // Stream<QuerySnapshot> fetchAllUser() async* {
  //   var uid = FirebaseAuth.instance.currentUser!.uid;

  //   var userDoc = await FirebaseFirestore.instance.doc('users/$uid/').get();
  //   var chatList = userDoc.data()!['chatRoomRecords'].toList();

  //   var query = FirebaseFirestore.instance
  //       .collection('users')
  //       .where('uid', whereIn: chatList)
  //       .snapshots();
  //   print(query.length);
  //   yield* query;
  // }
}
