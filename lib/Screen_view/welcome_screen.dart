import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../Reusable_widget/padding_text.dart';
import '../../Reusable_widget/reusable_container.dart';
import '../Login_folder_screen/Signin_with_email_screen/sign_in_with_email.dart';
import '../Login_folder_screen/Signin_with_phone_screen/sign_in_with_phone.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const PaddingText(
              title:"Welcome" ,top: 108,),
            
            Lottie.asset("assets/lottie/Boy-Thinking.json"),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReusableContainer(title: "Sign In With Email", containerColor: Colors.black,
                    onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  SignInWithEmailScreen()));
                    },
                  ),
                  const SizedBox(height: 20,),
                  ReusableContainer(title: "Sign In With Phone", containerColor: Colors.black,
                    onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  SignInWithPhoneScreen()));
                    },
                  ),

                 const SizedBox(height:80,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
