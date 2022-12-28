// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int? itemCount;
  final double? height;
  final double? width;

  ShimmerList({this.itemCount, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          width: this.width == null ? 50 : this.width,
          height: height,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100);
  }
}
