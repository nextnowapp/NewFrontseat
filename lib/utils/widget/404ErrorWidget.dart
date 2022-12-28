import 'package:flutter/material.dart';

class widget_error_404 extends StatelessWidget {
  const widget_error_404({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Icon with error message
        Center(
          child: Icon(
            Icons.warning_rounded,
            color: Colors.red[300],
            size: 50,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Something went wrong!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.red[300],
          ),
        ),
      ],
    );
  }
}
