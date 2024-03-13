import 'package:flutter/material.dart';

class text extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign align;
  const text(
      {super.key,
      required this.title,
      required this.fontSize,
      required this.fontWeight,
      required this.color,
      required this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: align,
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
