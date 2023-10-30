import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app_using_firebase/Login_folder_screen/Signin_with_email_screen/sign_up_with_email.dart';
import '../../Reusable_widget/padding_text.dart';
import '../../Reusable_widget/reusable_container.dart';
import '../../Reusable_widget/textfield_widget.dart';
import '../../Screen_view/home_screen.dart';

class SignInWithEmailScreen extends StatelessWidget {
SignInWithEmailScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void logInAccount()async{
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if(email == "" || password == ""){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red,content:Text("lease fill all the details!")));
        log("Please enter email & password!");
      }
      else{
        try{
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          if(userCredential.user != null){
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userId:userCredential.user!.uid,)));
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:Text("User logged in!"),backgroundColor: Colors.green,),
            );
          }
        }
        on FirebaseAuthException catch(ex){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:Text(ex.code.toString()),backgroundColor: Colors.red,),
          );
          log(ex.code.toString());
        }
      }
    }

    return Scaffold(
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///___ Headline text
              const PaddingText(
                title: "Sign in with email",top: 120,
              ),
              const SizedBox(height:180,),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ///___ Enter email id
                  TextFiledWidget(
                    controller:emailController ,
                    hintText: "Enter email id",
                    iconData: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20,),

                  ///___ Enter password
                  TextFiledWidget(
                    controller:passwordController ,
                    hintText: "Enter password",
                    iconData: Icons.lock_open_rounded,
                  ),
                  const SizedBox(height:40,),

                  ///___ Sign In button
                  ReusableContainer(
                      title:"Sign In", containerColor:Colors.black,
                      onTap: (){
                        logInAccount();
                      }
                  ),
                  const SizedBox(height: 25,),

                  ///___ Create a account
                  TextButton(onPressed:(){
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  SignUpWithEmailScreen()));
                  }, child: const Text("Create a account...",style: TextStyle(fontSize: 17,color: Colors.blue),))

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
