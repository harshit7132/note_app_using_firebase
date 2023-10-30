import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Reusable_widget/padding_text.dart';
import '../../Reusable_widget/reusable_container.dart';
import '../../Reusable_widget/textfield_widget.dart';
import '../../Screen_view/home_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String verificationId;
  final int phoneNumber;
 const VerifyOtpScreen({super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

  void verifyOTP()async{
    String otp = otpController.text.trim();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId:widget.verificationId, smsCode: otp);
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if(userCredential.user != null){
        FirebaseFirestore.instance.collection("user id").doc(userCredential.user!.uid).collection("user data").add({"phone":widget.phoneNumber});
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userId:userCredential.user!.uid)));
      }
    }
    on FirebaseAuthException catch(ex){
      log(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PaddingText(
                    title: "Verify OTP", top:80),

                Column(
                  children: [
                    const SizedBox(height:250,),
                    TextFiledWidget(
                      controller: otpController,
                      hintText: "Enter your otp",
                      iconData: Icons.numbers,

                    ),
                    const SizedBox(height: 30,),

                    ReusableContainer(
                      title: "Verify",
                      containerColor: Colors.black,
                      onTap: (){
                        verifyOTP();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
