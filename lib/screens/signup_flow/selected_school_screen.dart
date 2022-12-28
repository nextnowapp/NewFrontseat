import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectedSchoolScreen extends StatefulWidget {
  final Map<String, dynamic> map;
  final String schoolName;
  final String schoolID;
  final String schoolUrl;
  final String schoolLogo;
  final String passcode;
  SelectedSchoolScreen(
      {Key? key,
      required this.schoolID,
      required this.schoolUrl,
      required this.schoolName,
      required this.schoolLogo,
      required this.map,
      required this.passcode})
      : super(key: key);

  @override
  State<SelectedSchoolScreen> createState() => _SelectedSchoolScreenState();
}

class _SelectedSchoolScreenState extends State<SelectedSchoolScreen> {
  @override
  Widget build(BuildContext context) {
  return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SvgPicture.asset(
                  'assets/images/doodle_bg.svg',
                  alignment: Alignment.center,
                  color: const Color.fromARGB(255, 65, 143, 255),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: 80,
              height: MediaQuery.of(context).size.height - 100,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'You are at the right school and you just passed the security check at the gate!!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20, top: 60, right: 20, bottom: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Welcome to our',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Image.network(
                            widget.schoolLogo,
                            height: 60,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${widget.schoolName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${widget.schoolUrl}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[600],
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.grey, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    '< Go back',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[600],
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 252, 121, 121),
                                          Color.fromARGB(255, 254, 34, 34),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )),
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: const Text(
                                      'Next >',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
