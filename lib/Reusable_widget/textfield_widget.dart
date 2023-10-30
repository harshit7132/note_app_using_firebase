import 'package:flutter/material.dart';

class TextFiledWidget extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController controller;
  const TextFiledWidget({super.key, required this.hintText, required this.iconData, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child:  Padding(
        padding: const EdgeInsets.symmetric(vertical:3.0),
        child: TextField(
          controller:controller ,
          style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              prefixIcon: Icon(iconData),
              hintText:hintText,
              hintStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
              border: InputBorder.none
          ),
        ),
      ),
    );
  }
}
