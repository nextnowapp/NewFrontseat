// import 'dart:async';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:nextschool/utils/Utils.dart';
// import 'package:nextschool/utils/widget/customLoader.dart';
// import 'package:path/path.dart' as Path;
// import 'package:recase/recase.dart';
// import 'package:uuid/uuid.dart';

// class conversationScreen extends StatefulWidget {
//   final Map<String, dynamic>? userMap;
//   final String chatRoomId;

//   conversationScreen({required this.userMap, required this.chatRoomId});

//   @override
//   State<conversationScreen> createState() => _conversationScreenState();
// }

// class _conversationScreenState extends State<conversationScreen> {
//   TextEditingController _messageController = TextEditingController();
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   ScrollController _controller = ScrollController();

//   Future getImage() async {
//     ImagePicker()
//         .pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     )
//         .then((image) async {
//       String fileName = const Uuid().v4();
//       var extension = Path.extension(image!.path);
//       var uid = FirebaseAuth.instance.currentUser!.uid;
//       print(extension);
//       var ref = FirebaseStorage.instance
//           .ref()
//           .child('images/$uid/${this.widget.userMap!['uid']}')
//           .child('$fileName.$extension');
//       var uploadTask = await ref.putFile(File(image.path));
//       String imageUrl = await uploadTask.ref.getDownloadURL();
//       await _onSendMessage('image', imageUrl);
//       print(imageUrl);
//     });
//   }

//   Future openFileExplorer() async {
//     setState(() {});
//     try {
//       FilePickerResult file = await (FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowMultiple: true,
//       ) as FutureOr<FilePickerResult>);
//       for (int i = 0; i < file.files.length; i++) {
//         String suffix = const Uuid().v4();
//         var extension = Path.extension(file.files[i].path!);
//         var uid = FirebaseAuth.instance.currentUser!.uid;
//         var fileName = '$suffix${file.files[i].name}.$extension';
//         // print("Document ${file.files[i].name}");
//         var ref = FirebaseStorage.instance
//             .ref()
//             .child('images/$uid/${this.widget.userMap!['uid']}')
//             .child('$fileName');
//         var uploadTask = await ref.putData(file.files[i].bytes!);
//         String docUrl = await uploadTask.ref.getDownloadURL();
//         await _onSendMessage('doc', docUrl);
//         print(docUrl);
//       }
//     } on PlatformException catch (e) {
//       print('Unsupported operation' + e.toString());
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     //scroll to end
//     Timer(const Duration(milliseconds: 300),
//         () => _controller.jumpTo(_controller.position.maxScrollExtent));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final roundedContainer = ClipRRect(
//       borderRadius: BorderRadius.circular(30.0),
//       child: Container(
//         color: Colors.grey[300],
//         child: Row(
//           children: <Widget>[
//             const SizedBox(width: 12.0),
//             // IconButton(onPressed: (){}, icon: Icon(Icons.insert_emoticon,
//             //     size: 24.0, color: Theme.of(context).hintColor),),

//             const SizedBox(width: 8.0),
//             Expanded(
//               child: TextField(
//                 keyboardType: TextInputType.multiline,
//                 minLines: 1,
//                 //Normal textInputField will be displayed
//                 maxLines: 5,
//                 onTap: () {
//                   setState(() {
//                     Timer(
//                         const Duration(milliseconds: 300),
//                         () => _controller
//                             .jumpTo(_controller.position.maxScrollExtent));
//                   });
//                 },
//                 controller: _messageController,
//                 cursorHeight: 19,
//                 style: const TextStyle(fontSize: 16),
//                 decoration: InputDecoration(
//                   hintText: 'Message',
//                   hintStyle: const TextStyle(fontSize: 16),
//                   suffixIcon: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             openFileExplorer();
//                           },
//                           icon: const Icon(
//                             Icons.attachment,
//                           ),
//                           color: Colors.grey[600]),
//                       IconButton(
//                           onPressed: () {
//                             getImage();
//                           },
//                           icon: const Icon(Icons.image),
//                           color: Colors.grey[600]),
//                     ],
//                   ),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             // Icon(Icons.attach_file,
//             //     size: 24.0, color: Theme.of(context).hintColor),
//             // SizedBox(width: 8.0),
//             // Icon(Icons.camera_alt,
//             //     size: 24.0, color: Theme.of(context).hintColor),
//             const SizedBox(width: 12.0),
//           ],
//         ),
//       ),
//     );

//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       extendBody: true,
//       body: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             toolbarHeight: 60,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(25),
//               ),
//             ),
//             backgroundColor: const Color(0xFF222744),
//             title: StreamBuilder<DocumentSnapshot>(
//                 stream: _firestore
//                     .collection('users')
//                     .doc(widget.userMap!['uid'])
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   return Row(
//                     children: <Widget>[
//                       CircleAvatar(
//                         backgroundImage:
//                             NetworkImage(snapshot.data!['profile']),
//                       ),
//                       const SizedBox(
//                         width: 8.0,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             snapshot.data!['name'],
//                             style:
//                                 const TextStyle(color: Colors.white, fontSize: 18.0),
//                           ),
//                           const SizedBox(
//                             height: 3.0,
//                           ),
//                           Text(
//                             snapshot.data!['status'] == 'Offline'
//                                 ? ''
//                                 : 'Online',
//                             style:
//                                 const TextStyle(color: Colors.white, fontSize: 10.0),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 }),
//             actions: <Widget>[
//               PopupMenuButton(itemBuilder: (context) {
//                 return [
//                   const PopupMenuItem(
//                     child: Text('Clear Chat'),
//                     value: 1,
//                   ),
//                   const PopupMenuItem(
//                     child: Text('Delete Chat'),
//                     value: 2,
//                   ),
//                   const PopupMenuItem(
//                     child: Text('Report'),
//                     value: 3,
//                   ),
//                 ];
//               }, onSelected: (dynamic value) {
//                 if (value == 1) {
//                   setState(() {
//                     clearChat();
//                     Utils.showThemeToast('Chat Cleared Successfully');
//                   });
//                 }
//               }),
//             ],
//           ),
//           bottomNavigationBar: Padding(
//             padding: const EdgeInsets.only(bottom: 8.0, left: 10),
//             child: Container(
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: roundedContainer,
//                   ),
//                   const SizedBox(
//                     width: 10.0,
//                   ),
//                   IconButton(
//                     alignment: Alignment.center,
//                     onPressed: () {
//                       _onSendMessage('text', _messageController.text);
//                       setState(() {
//                         Timer(
//                             const Duration(milliseconds: 300),
//                             () => _controller
//                                 .jumpTo(_controller.position.maxScrollExtent));
//                       });
//                     },
//                     icon: const Icon(
//                       Icons.send,
//                       size: 24,
//                       color: Color(0xFF222744),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: Container(
//             padding: const EdgeInsets.only(bottom: 10.0, top: 10),
//             height: MediaQuery.of(context).size.height,
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('chatRoom')
//                   .doc(this.widget.chatRoomId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     controller: _controller,
//                     itemCount: snapshot.data!.docs.length,
//                     addAutomaticKeepAlives: true,
//                     itemBuilder: (context, index) => snapshot.data!.docs[index]
//                                 ['timestamp'] ==
//                             null
//                         ? Container()
//                         : Container(
//                             padding: const EdgeInsets.only(
//                                 top: 5.0, left: 12.0, right: 12.0, bottom: 5.0),
//                             alignment: snapshot.data!.docs[index]['sender'] ==
//                                     FirebaseAuth.instance.currentUser!.uid
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             child: Container(
//                               constraints: BoxConstraints(
//                                 maxWidth:
//                                     MediaQuery.of(context).size.width * 0.7,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.white,
//                               ),
//                               child: Padding(
//                                 padding: (snapshot.data!.docs[index]['type'] ==
//                                         'text')
//                                     ? const EdgeInsets.only(
//                                         top: 12.0, left: 20.0, right: 20.0)
//                                     : const EdgeInsets.all(4.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Visibility(
//                                       visible: snapshot.data!.docs[index]
//                                               ['sender'] !=
//                                           FirebaseAuth
//                                               .instance.currentUser!.uid,
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             snapshot.data!.docs[index]
//                                                 ['senderName'],
//                                             textAlign: TextAlign.left,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.green,
//                                               fontSize: 16.0,
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     (snapshot.data!.docs[index]['type'] ==
//                                             'text')
//                                         ? Wrap(
//                                             alignment:
//                                                 WrapAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               Text(
//                                                 snapshot.data!.docs[index]
//                                                     ['message'],
//                                                 style: const TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 16.0,
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: getTimeWidget(snapshot
//                                                     .data!
//                                                     .docs[index]['timestamp']),
//                                               ),
//                                             ],
//                                           )
//                                         : Wrap(
//                                             alignment:
//                                                 WrapAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12.0),
//                                                 child: CachedNetworkImage(
//                                                   fadeInCurve: Curves.easeIn,
//                                                   imageUrl: snapshot.data!
//                                                       .docs[index]['message'],
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: getTimeWidget(snapshot
//                                                     .data!
//                                                     .docs[index]['timestamp']),
//                                               ),
//                                             ],
//                                           )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                   );
//                 }
//                 return Dialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: Container(
//                     height: 100,
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const CustomLoader(),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         const Text(
//                           'Loading Messages',
//                           style: TextStyle(
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _onSendMessage(String type, String message) async {
//     if (message.isNotEmpty) {
//       Map<String, dynamic> messageMap = {
//         'message': message,
//         'sender': FirebaseAuth.instance.currentUser!.uid,
//         'reciever': this.widget.userMap!['uid'],
//         'timestamp': FieldValue.serverTimestamp(),
//         'senderName': FirebaseAuth.instance.currentUser!.displayName!.titleCase,
//         'recieverName': this.widget.userMap!['name'],
//         'isMessageDeletedBySender': false,
//         'isMessageDeletedByReciever': false,
//         'isMessageDeletedByEveryone': false,
//         'isMessageRead': false,
//         'type': type,
//       };
//       _firestore
//           .collection('chatRoom')
//           .doc(this.widget.chatRoomId)
//           .collection('messages')
//           .add(messageMap);
//       var userRecord = _firestore
//           .doc('users/${FirebaseAuth.instance.currentUser!.uid}')
//           .get();
//       userRecord.then((value) {
//         //create chatroomrecord in current user document
//         value.data()!.containsKey('chatRoomRecords')
//             ? _firestore
//                 .doc('users/${FirebaseAuth.instance.currentUser!.uid}')
//                 .update({
//                 'chatRoomRecords':
//                     FieldValue.arrayUnion([this.widget.userMap!['uid']]),
//               })
//             : _firestore
//                 .doc('users/${FirebaseAuth.instance.currentUser!.uid}')
//                 .set({
//                 'chatRoomRecords':
//                     FieldValue.arrayUnion([this.widget.userMap!['uid']]),
//               });
//         //create chatroomrecord in current chat partner document
//         value.data()!.containsKey('chatRoomRecords')
//             ? _firestore.doc('users/${this.widget.userMap!['uid']}').update({
//                 'chatRoomRecords': FieldValue.arrayUnion(
//                     [FirebaseAuth.instance.currentUser!.uid]),
//               })
//             : _firestore.doc('users/${this.widget.userMap!['uid']}').set({
//                 'chatRoomRecords': FieldValue.arrayUnion(
//                     [FirebaseAuth.instance.currentUser!.uid]),
//               });
//       });

//       _messageController.clear();
//     } else
//       print('Please enter a message');
//   }

//   String getTime(Timestamp timestamp) {
//     var time = timestamp.toDate();
//     var timeString = DateFormat.jm().format(time);
//     return timeString;
//   }

//   Widget getTimeWidget(Timestamp timestamp) {
//     var time = timestamp.toDate();
//     var timeString = DateFormat.jm().format(time);
//     return Text(
//       timeString,
//       style: const TextStyle(
//         color: Colors.grey,
//         fontSize: 10.0,
//       ),
//     );
//   }

//   //function to get data (DD:MM:YYYY) from timestamp

//   Future clearChat() async {
//     _firestore
//         .collection('chatRoom')
//         .doc(this.widget.chatRoomId)
//         .collection('messages')
//         .get()
//         .then((value) {
//       value.docs.forEach((element) {
//         if (FirebaseAuth.instance.currentUser!.uid ==
//             element.data()['sender']) {
//           element.reference.update({
//             'isMessageDeletedBySender': true,
//           });
//         } else {
//           element.reference.update({
//             'isMessageDeletedByReciever': true,
//           });
//         }
//       });
//     });
//   }
// }
