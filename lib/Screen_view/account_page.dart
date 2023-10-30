import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app_using_firebase/Screen_view/welcome_screen.dart';
import '../Reusable_widget/reusable_container.dart';

class AccountPage extends StatefulWidget {
  final String userId;
  const AccountPage({super.key, required this.userId});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {


  @override
  Widget build(BuildContext context) {

    void logOutUser()async{
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));
    }

    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
          padding: const EdgeInsets.only(left:40.0,right: 40,top: 40),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                ///___ User image
                Container(
                  height: 100,width: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                  color: Colors.black54,
                  ),
                  child: const Icon(Icons.person,size: 40,),
                ),

                ///___ User name
                const Padding(
                  padding: EdgeInsets.only(top:45,left:15),
                  child: TextWidget(title: "",value: "User name",),
                ),
              ],
            ),

             ///___ User data
             Padding(
               padding: const EdgeInsets.symmetric(horizontal:10.0),
               child: Column(
                 children: [
                   const SizedBox(height:25),
                   //  TextWidget(title: "Name: ",value:"${FirebaseFirestore.instance.collection("user id").doc(widget.userId).collection("user data").doc().get()}",),
                   const SizedBox(height:10),
                   TextWidget(title: "Email,  ",value:"${FirebaseAuth.instance.currentUser!.email}",),
                   const SizedBox(height:10),
                   TextWidget(title:"Phone, ", value:"${FirebaseAuth.instance.currentUser!.phoneNumber}" ),

                 ],
               ),
             )
          ],
          ),
          ),

        ///___ LogOUt button
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height:25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:70.0),
              child: ReusableContainer(title:"Log Out", containerColor: CupertinoColors.black, onTap: (){logOutUser();}),
            ),
          ],
        )
      ],
    );
  }
}
class TextWidget extends StatelessWidget {
  final String title;
  final String value;
  const TextWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        Text(title,style: const TextStyle(fontSize:19,fontWeight: FontWeight.w500),),
        Text(value,style: const TextStyle(fontSize:19,fontWeight: FontWeight.w500),),
      ],
    );
  }
}
