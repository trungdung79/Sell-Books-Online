import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final String hintText;
  final controller;
  const TextInputWidget({Key? key, required this.hintText, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          //border: OutlineInputBorder(),
          hintText: hintText,
        ),
        controller: controller,
      ),
    );
  }
}
