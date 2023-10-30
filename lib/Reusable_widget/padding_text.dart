import 'package:flutter/cupertino.dart';

class PaddingText extends StatelessWidget {
  final String title;
  final double top;
  const PaddingText({super.key, required this.title, required this.top});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:top),
      child: Text(title,style:const TextStyle(fontWeight: FontWeight.w500,fontSize:25),),
    );

  }
}
