import 'package:flutter/material.dart';
import 'package:get/get.dart';

class header extends StatelessWidget {
  final Widget child;
  const header({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
        margin: EdgeInsets.only(
          top: Get.height * 0.05,
        ),
        child: child,
      ),
    );
  }
}
