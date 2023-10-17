// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app_using_firebase/constants/img_constant.dart';
import 'package:note_app_using_firebase/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  //* get data from super class
  String userId;

  ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imgUrlFile;
  late FirebaseStorage firebaseStorage;

  void initState() {
    super.initState();
    //* initial state
    firebaseStorage = FirebaseStorage.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                //* Image Picker
                var imageFromGallery = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (imageFromGallery != null) {
                  // //* Get Value for Gallery
                  // imgUrlFile = File(imageFromGallery.path);
                  var cropFile = await ImageCropper().cropImage(
                    sourcePath: imageFromGallery.path,
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.deepOrange,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        title: 'Cropper',
                      ),
                      WebUiSettings(
                        context: context,
                        presentStyle: CropperPresentStyle.dialog,
                        boundary: const CroppieBoundary(
                          width: 520,
                          height: 520,
                        ),
                        viewPort: const CroppieViewPort(
                            width: 480, height: 480, type: 'circle'),
                        enableExif: true,
                        enableZoom: true,
                        showZoomer: true,
                      ),
                    ],
                  );

                  if (cropFile != null) {
                    imgUrlFile = File(cropFile.path);
                  }

                  setState(() {});
                }
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: imgUrlFile != null
                      ? DecorationImage(
                          image: FileImage(imgUrlFile!), fit: BoxFit.cover)
                      : const DecorationImage(
                          image: AssetImage(ImageConstant.profileImg)),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  var currentTime = DateTime.now().millisecondsSinceEpoch;
                  if (imgUrlFile != null) {
                    var uploadImg = firebaseStorage
                        .ref()
                        .child('images/profilephotos/img_$currentTime.jpg');

                    try {
                      uploadImg.putFile(imgUrlFile!).then(
                        (p0) async {
                          print('Image Loaded!!');

                          //* Upload Firebasr Data using url.
                          var downloadUrl = await p0.ref.getDownloadURL();

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .update(
                                UserModel(
                                  profilePic: downloadUrl,
                                ).toMap(),
                              )
                              .then((value) => print('Profile Photo Updated'));
                        },
                      );
                    } catch (e) {
                      print('Error is: ' + e.toString());
                    }
                  }
                },
                child: const Text('Update Profile'))
          ],
        ),
      ),
    );
  }
}
