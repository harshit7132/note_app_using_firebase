import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../Models/note_model.dart';
import '../../Reusable_widget/reusable_container.dart';
import '../../Reusable_widget/textfield_widget.dart';


class NoteApp extends StatefulWidget {
  final String userId;
  const NoteApp({super.key, required this.userId});

  @override
  State<NoteApp> createState() => _NoteAppState();
}
class _NoteAppState extends State<NoteApp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? profilePic;

  void saveNote()async{
    String name = nameController.text.trim();
    String position = positionController.text.trim();
    nameController.clear();
    positionController.clear();
    if(name != "" && position != "" ){
      var userData = NoteModel(name: name, position: position,dateTime: "${DateFormat('jms').format(DateTime.now())},  ${DateFormat('yMMMd').format(DateTime.now())}").toMap();

      FirebaseFirestore.instance.collection("user id").doc(widget.userId).collection("user notes").add(userData);

      log("User created!");
    }
    else{
      log("Please fill all the fields!");
    }
    setState(() {
      profilePic = null;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Note app"),
        titleTextStyle: TextStyle(color: Colors.black,fontSize:21,fontWeight: FontWeight.w600),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
                 stream: FirebaseFirestore.instance.collection("user id").doc(widget.userId).collection("user notes").orderBy("name").snapshots(),

                builder: (context, snapshot) {
                 if(snapshot.connectionState == ConnectionState.active){
                   if(snapshot.hasData && snapshot.data != null){
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                          Map<String,dynamic> userMap = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10,right: 10),
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.black,
                                child:Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
                                    child: Stack(
                                      children: [

                                        ///___ Note list
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [

                                            const SizedBox(height: 10,),
                                            NoteText(title:"Title: ", value: userMap['name']),
                                            const SizedBox(height: 10,),
                                            NoteText(title:"Description: ", value: userMap['position']),
                                            const SizedBox(height:35,)
                                          ],
                                        ),
                                        ///___ Delete button
                                        Positioned(right:-10,top: -10,
                                          child: IconButton(onPressed:()async{
                                              await FirebaseFirestore.instance.collection("user id").doc(widget.userId).collection("user notes").doc(snapshot.data!.docs[index].id).delete();
                                          }, icon:const Icon(Icons.delete,size: 25,color: Colors.black54,)),
                                        ),

                                        ///___ Time date
                                        Positioned( bottom:0,right:5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Time Date- ${userMap['dateTime']}",style: const TextStyle(color: Colors.black54,fontSize:16,fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                )
                              ),
                            );
                          },),
                    );
                   }
                   else{
                     return const Center(child: Text("No data!"));
                   }
                 }
                 else{
                   return const Center(child: CircularProgressIndicator(color: Colors.black,),);
                 }
                },)
          ],
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        backgroundColor: CupertinoColors.black,
        label: const Icon(Icons.add),
        onPressed: (){
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CupertinoButton(
                      //     onPressed: ()async{
                      //      XFile? selectedImage = await ImagePicker().pickImage(source:ImageSource.gallery);
                      //      if(selectedImage != null){
                      //        File convertedFile = File(selectedImage.path);
                      //        setState(() {
                      //          profilePic = convertedFile;
                      //        });
                      //        log("image selected");
                      //      }
                      //      else{
                      //        log("no image selected");
                      //      }
                      //     },
                      //   child: Container(
                      //     height: 100,width: 100,
                      //     decoration: BoxDecoration(
                      //       color: Colors.black54,
                      //       borderRadius: BorderRadius.circular(4),
                      //       image: profilePic != null ? DecorationImage(image:FileImage(profilePic!) ):null,
                      //     ),
                      //   ),
                      //  /* child: CircleAvatar(radius: 50,
                      //     backgroundColor: Colors.black54,
                      //     backgroundImage: (profilePic != null) ? FileImage(profilePic!): null,
                      //   ),*/
                      // ),

                      TextFiledWidget(hintText:"Title", iconData:Icons.person, controller:nameController),
                      TextFiledWidget(hintText:"Description", iconData:Icons.pending, controller:positionController),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: ReusableContainer(title:"Save", containerColor: Colors.black, onTap: (){
                          Navigator.popUntil(context, (route) => route.isFirst);
                          saveNote();}),
                      )
                    ],
                  ),
                );
              },
          );
        },
      ),
    );
  }
}

class NoteText extends StatelessWidget {
  final String title;
  final String value;
  const NoteText({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(title +value,style: const TextStyle(fontSize: 19,fontWeight: FontWeight.w500),);

  }
}

