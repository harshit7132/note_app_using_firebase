import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  final String title;
  final Color containerColor;
  final VoidCallback onTap;
  const ReusableContainer({super.key, required this.title, required this.containerColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Container(
        height:45,width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color:containerColor),
        child: Center(child: Text(title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white))),
      ),
    );
  }
}
