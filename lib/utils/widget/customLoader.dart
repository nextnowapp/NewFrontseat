import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoader extends StatelessWidget {
  final String? lottiePath;
  final double? height;
  final double? width;

  const CustomLoader({Key? key, this.lottiePath, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height == null ? 80 : this.height,
      width: this.width == null ? 80 : this.width,
      child: this.lottiePath == null
          ? Lottie.asset('assets/lottie/loader_animation.json',
              height: 80, width: 80, fit: BoxFit.fitWidth)
          : Lottie.asset(this.lottiePath!,
              height: 80, width: 80, fit: BoxFit.fitWidth),
    );
  }
}
