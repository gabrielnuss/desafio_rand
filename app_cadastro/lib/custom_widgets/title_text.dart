import 'package:flutter/material.dart';

class TitleText extends StatefulWidget {
  const TitleText({super.key, this.text});
  final text;

  @override
  State<TitleText> createState() => _TitleTextState();
}

class _TitleTextState extends State<TitleText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
    );
  }
}
