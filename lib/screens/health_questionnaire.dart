// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:nextschool/utils/CustomAppBarWidget.dart';
// import 'package:nextschool/utils/Utils.dart';
// import 'package:nextschool/utils/model/HealthQuestionnaireFormModel.dart';
// import 'package:nextschool/utils/widget/submit_button.dart';

// class HealthQuestionnaire extends StatefulWidget {
//   const HealthQuestionnaire({Key? key}) : super(key: key);

//   @override
//   _HealthQuestionnaireState createState() => _HealthQuestionnaireState();
// }

// class _HealthQuestionnaireState extends State<HealthQuestionnaire> {
//   late SimulatedSubmitController submitController;
//   String? formString;
//   bool _submissionAttempted = false;
//   List<Questionnaire> questionnaireList = [
//     Questionnaire(
//       question:
//           'Have you or anyone in your household been in contact with someone that has tested positive for COVID-19?',
//       answers: [
//         'Yes',
//         'No',
//         'Not Sure',
//       ],
//       selectedAnswers: [],
//       type: 'radio',
//     ),
//     Questionnaire(
//       question: 'Do you have (you may select more than one option):',
//       answers: [
//         'Fever or chills / High temperature / Bloodshot or red eyes',
//         'A cough / Sore throat / Loss of taste or smell',
//         'Shortness of breath / Difficulty breathing / Body Pains / Physical Weakness / Fatigue/ Tired',
//         'Diarrhoea / Nausea / Vomiting',
//         'None of the above',
//       ],
//       selectedAnswers: [],
//       type: 'checkbox',
//     ),
//     Questionnaire(
//       question: 'Complete - I have:',
//       answers: [
//         'been out of SA (Last 6 weeks) or Province (Last 3 weeks)',
//         'been in contact with anyone suspected of being confirmed with COVID-19',
//         'None of the above',
//       ],
//       selectedAnswers: [],
//       type: 'checkbox',
//     ),
//   ];

//   @override
//   void initState() {
//     submitController = SimulatedSubmitController(
//       onPressed: submit,
//       onOpenError: () {
//         Utils.showErrorBottomSheet(context, 'Form Submission is locked 🙁',
//             'We are not accepting any new submissions at this time.');
//       },
//       onOpenSuccess: () {
//         Utils.showSuccessBottomSheet(context, 'Form Submission Successful 🎉');
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(
//         title: 'Health Questionnaire',
//       ),
//       body: body(),
//       bottomNavigationBar: SizedBox(
//         height: 60,
//         child: AnimatedBuilder(
//           animation: submitController,
//           builder: (context, child) {
//             return SubmitButton(
//               text: 'Submit',
//               successText: 'Submitted Successfully',
//               status: submitController.submitStatus,
//               onPressed: submitController.onPressed,
//               onError: submitController.openError,
//               onSuccess: submitController.openSuccess,
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> submit() async {
//     if (_submissionAttempted != true) {
//       setState(() {
//         _submissionAttempted = true;
//       });
//     }
//     if (questionnaireList[0].selectedAnswers!.length != 0 &&
//         questionnaireList[1].selectedAnswers!.length != 0 &&
//         questionnaireList[2].selectedAnswers!.length != 0) {
//       setState(() {
//         submitController.submitStatus = SubmitStatus.disabled;
//       });
//       var uid = FirebaseAuth.instance.currentUser!.uid;
//       var date = Utils.getDateFromTimeStamp(Timestamp.now())
//           .replaceAll(' ', '')
//           .replaceAll(',', '');
//       var schoolUrl = await FirebaseAuth.instance.currentUser!
//           .getIdTokenResult()
//           .then((value) => value.claims!['schoolUrl']);
//       var schoolRef = await FirebaseFirestore.instance
//           .collection('school')
//           .where('school_base_url', isEqualTo: schoolUrl)
//           .get();
//       var schoolId = schoolRef.docs[0].id;
//       await FirebaseFirestore.instance
//           .doc('healthQuiz/$schoolId')
//           .get()
//           .then((value) async {
//         if (value.exists) {
//           if (value.data()!.containsKey('locked')) {
//             if (value.data()!['locked'] == true) {
//               setState(() {
//                 submitController.submitStatus = SubmitStatus.error;
//               });
//             } else {
//               setState(() {
//                 submitController.submitStatus = SubmitStatus.busy;
//               });
//               try {
//                 await FirebaseFirestore.instance
//                     .doc('healthQuiz/$schoolId/$date/$uid')
//                     .set({
//                   '1': questionnaireList[0].selectedAnswers,
//                   '2': questionnaireList[1].selectedAnswers,
//                   '3': questionnaireList[2].selectedAnswers,
//                   'timestamp': Timestamp.now(),
//                   'date': Utils.getDateFromTimeStamp(Timestamp.now()),
//                 });
//                 setState(() {
//                   submitController.submitStatus = SubmitStatus.success;
//                 });
//               } catch (e) {
//                 print(e);
//               }
//             }
//           }
//         } else {
//           await FirebaseFirestore.instance
//               .doc('healthQuiz/$schoolId/$date/$uid')
//               .set({
//             '1': questionnaireList[0].selectedAnswers,
//             '2': questionnaireList[1].selectedAnswers,
//             '3': questionnaireList[2].selectedAnswers,
//             'timestamp': Timestamp.now(),
//             'date': Utils.getDateFromTimeStamp(Timestamp.now()),
//           }).then((value) {
//             setState(() {
//               submitController.submitStatus = SubmitStatus.success;
//             });
//             Utils.showLoginToast('Submitted Successfully');
//           }).onError((dynamic error, stackTrace) {
//             Utils.showErrorToast('Error Occured');
//           });
//         }
//       });
//     }
//   }

//   Widget body() {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: ListTile(
//               title: Text(
//                 '${index + 1}. ${questionnaireList[index].question}',
//                 style: const TextStyle(
//                     color: Colors.black,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w600),
//               ),
//               subtitle: Padding(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     ...questionnaireList[index].answers!.map((option) {
//                       return getOptionsWidget(option, index);
//                     }).toList(),
//                     Visibility(
//                         child: Container(
//                           padding:
//                               const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: const Color(0xFF22222),
//                           ),
//                           child: const Text(
//                             '* Please select atleast any one option',
//                             style: TextStyle(fontSize: 10, color: Colors.red),
//                           ),
//                         ),
//                         visible:
//                             questionnaireList[index].selectedAnswers!.isEmpty &&
//                                 _submissionAttempted),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       itemCount: questionnaireList.length,
//     );
//   }

//   Widget getOptionsWidget(String option, int index) {
//     if (questionnaireList[index].type == 'radio') {
//       return RadioListTile(
//         title: Text(
//           option,
//           style: const TextStyle(
//               color: Colors.black54,
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w400),
//         ),
//         value: option,
//         groupValue: formString,
//         onChanged: (dynamic value) {
//           setState(() {
//             _submissionAttempted = false;
//           });
//           setState(() {
//             formString = value;
//             questionnaireList[index].selectedAnswers!.clear();
//             questionnaireList[index].selectedAnswers!.add(value);
//             print(questionnaireList[index].selectedAnswers);
//           });
//         },
//       );
//     } else {
//       return CheckboxListTile(
//         value: questionnaireList[index].selectedAnswers!.contains(option),
//         title: Text(
//           option,
//           style: const TextStyle(
//               color: Colors.black54,
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w400),
//         ),
//         onChanged: (value) {
//           setState(() {
//             _submissionAttempted = false;
//           });
//           if (option == 'None of the above') {
//             setState(() {
//               questionnaireList[index].selectedAnswers!.clear();
//               questionnaireList[index]
//                   .selectedAnswers!
//                   .add('None of the above');
//             });
//           } else {
//             setState(() {
//               if (value!) {
//                 questionnaireList[index]
//                     .selectedAnswers!
//                     .remove('None of the above');
//                 questionnaireList[index].selectedAnswers!.add(option);
//                 print(questionnaireList[index].selectedAnswers);
//               } else {
//                 questionnaireList[index]
//                     .selectedAnswers!
//                     .remove('None of the above');
//                 questionnaireList[index].selectedAnswers!.remove(option);
//                 print(questionnaireList[index].selectedAnswers);
//               }
//             });
//           }
//         },
//       );
//     }
//   }
// }
