import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app_using_firebase/Login_folder_screen/Signin_with_phone_screen/verify_otp_with_phone.dart';
import '../../Reusable_widget/padding_text.dart';
import '../../Reusable_widget/reusable_container.dart';
import '../../Reusable_widget/textfield_widget.dart';

class SignInWithPhoneScreen extends StatelessWidget {
  SignInWithPhoneScreen({super.key});
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ///___ Send otp
    void sendOTP()async{
      String phone = "+91"+phoneController.text.trim();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:phone,
        codeSent: (verificationId, resendToken){
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> VerifyOtpScreen(verificationId: verificationId,phoneNumber:int.parse(phone),)));
        },
        verificationCompleted: (credential){},
        verificationFailed: (ex){
          log(ex.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId){},
        timeout: const Duration(seconds: 30),
      );
    }


    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PaddingText(
                    title: "Phone Auth", top:80),

                Column(
                  children: [
                    const SizedBox(height:250,),
                    TextFiledWidget(
                      controller: phoneController,
                      hintText: "Enter your number",
                      iconData: Icons.numbers,

                    ),
                    const SizedBox(height: 30,),

                    ReusableContainer(
                      title: "Submit",
                      containerColor: Colors.black,
                      onTap: (){
                        sendOTP();
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
