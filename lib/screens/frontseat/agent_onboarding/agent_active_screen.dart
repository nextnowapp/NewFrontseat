import 'package:flutter/material.dart';

import '../nav_bar.dart';

class AgentActiveScreen extends StatelessWidget {
  const AgentActiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Yor are an ACTIVE AGENT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Icon(
              Icons.verified,
              color: Colors.green,
              size: 30,
            ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const BottomBar(
                              index: 1,
                            ))));
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('View Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
