import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app_using_firebase/Login_folder_screen/Signin_with_email_screen/sign_in_with_email.dart';
import '../../Reusable_widget/padding_text.dart';
import '../../Reusable_widget/reusable_container.dart';
import '../../Reusable_widget/textfield_widget.dart';

class SignUpWithEmailScreen extends StatelessWidget {
   SignUpWithEmailScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();


   @override
  Widget build(BuildContext context) {

    ///___ Create account function
    void createAccount()async{
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String cPassword = cPasswordController.text.trim();
      if(name == "" || email == "" || password == "" || cPassword == ""){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red,content:Text("lease fill all the details!")));
        log("Please fill all the details!");

      }
      else if(password != cPassword){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red,content:Text("Password do not match!")));
        log("Password do not match!");

      }
      else{
        try{
         UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
         if(userCredential.user != null){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green,content:Text("Account created!")));
            FirebaseFirestore.instance.collection("user id").doc(userCredential.user!.uid).collection("user data").add({"name":name,"email":email,"password":password });
            Navigator.pop(context);
            log("User created!");
          }
        }
        on FirebaseAuthException catch(ex){
          if (ex.code == 'weak-password') {
            print('The password provided is too weak.');
          }
          else if (ex.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
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
                title: "Sign up with email",top: 120,
              ),
              const SizedBox(height:130,),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///___ Enter name
                  TextFiledWidget(
                    controller:nameController ,
                    hintText: "Enter name",
                    iconData: Icons.person,
                  ),
                  const SizedBox(height: 20,),

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
                  const SizedBox(height:20,),

                  ///___ Enter cPassword
                  TextFiledWidget(
                    controller:cPasswordController ,
                    hintText: "Enter password",
                    iconData: Icons.lock_open_rounded,

                  ),
                  const SizedBox(height:40,),


                  ///___ Sign In button
                  ReusableContainer(
                      title:"Sign In", containerColor:Colors.black,
                      onTap: (){
                        createAccount();
                      }
                  ),
                  const SizedBox(height: 25,),

                  ///___ Create a account
                  TextButton(onPressed:(){
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  SignInWithEmailScreen()));
                  }, child: const Text("I have a account...",style: TextStyle(fontSize: 17,color: Colors.blue),))

                ],
              )
            ],
          ),
          ),
      ),
    );
  }
}
