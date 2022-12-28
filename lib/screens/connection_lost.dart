import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/Home.dart';
import 'package:nextschool/screens/choose_school.dart';

class ConnectionLostScreen extends StatelessWidget {
  ConnectionLostScreen({Key? key}) : super(key: key);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: ListView(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.wifi),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'No Connection',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Check your connection and try again',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
                const SizedBox(
                  height: 10,
                ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     backgroundColor:  MaterialStateProperty.all<Color>(Color(0xff4E88FF)),
                //     foregroundColor:  MaterialStateProperty.all<Color>(Color(0xff4E88FF)),
                //   ),
                //   child: const Text(
                //     'Check again',
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                //   onPressed: () {
                //     print('no connection available');
                //     // Navigator.pushNamed(context, '/');
                //     // MediaQuery(
                //     //   child: Text('fgfgf'),
                //     //   data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                //     // );
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(builder: (context) => ChooseSchool()
                //           // Home(t, i, this.widget.rule)
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
