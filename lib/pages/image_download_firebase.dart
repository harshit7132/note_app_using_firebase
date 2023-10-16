import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//*Without path get all data..

class ImageFirebase extends StatefulWidget {
  const ImageFirebase({super.key});

  @override
  State<ImageFirebase> createState() => _ImageFirebaseState();
}

class _ImageFirebaseState extends State<ImageFirebase> {
  late FirebaseStorage firebaseStorage;
  List<String> listimgURL = [];

  @override
  void initState() {
    super.initState();
    //* initial state
    firebaseStorage = FirebaseStorage.instance;

    var storageRef = firebaseStorage.ref();

    //* Fetch Data of firebase

    getImageUrl(storageRef);
  }

  //* Download calling
  void getImageUrl(Reference ref) async {
    //* List of all data..
    ListResult imgUrlRef = await ref.child("images").listAll();

    for (var element in imgUrlRef.items) {
      var imgURL = await element.getDownloadURL();
      listimgURL.add(imgURL);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Firebase Download'),
      ),
      body: listimgURL.isNotEmpty
          ? ListView.builder(
              itemCount: listimgURL.length,
              itemBuilder: (_, index) {
                return Image.network(listimgURL[index]);
              })
          : const Text('No Data Found'),
    );
  }
}








































//* List of Images

// class ImageFirebase extends StatefulWidget {
//   const ImageFirebase({super.key});

//   @override
//   State<ImageFirebase> createState() => _ImageFirebaseState();
// }

// class _ImageFirebaseState extends State<ImageFirebase> {
//   late FirebaseStorage firebaseStorage;
//   List<String> listimgURL = [];

//   @override
//   void initState() {
//     super.initState();
//     //* initial state
//     firebaseStorage = FirebaseStorage.instance;

//     var storageRef = firebaseStorage.ref();

//     //* Fetch Data of firebase

//     var imgUrlRef = storageRef.child("images/hacked.png");
//     getImageUrl(imgUrlRef);
//     var imgUrlRef2 = storageRef.child("images/5.webp");
//     getImageUrl(imgUrlRef2);
//     var imgUrlRef3 = storageRef.child("images/6.webp");
//     getImageUrl(imgUrlRef3);
//   }

//   //* Download calling
//   void getImageUrl(Reference ref) async {
//     var imgURL = await ref.getDownloadURL();

//     listimgURL.add(imgURL);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Firebase Download'),
//       ),
//       body: listimgURL.isNotEmpty
//           ? ListView.builder(
//               itemCount: listimgURL.length,
//               itemBuilder: (_, index) {
//                 return Image.network(listimgURL[index]);
//               })
//           : const Text('No Data Found'),
//     );
//   }
// }

































//* Single Image Data..
// class ImageFirebase extends StatefulWidget {
//   const ImageFirebase({super.key});

//   @override
//   State<ImageFirebase> createState() => _ImageFirebaseState();
// }

// class _ImageFirebaseState extends State<ImageFirebase> {
//   late FirebaseStorage firebaseStorage;
//   String imgURL = '';

//   @override
//   void initState() {
//     super.initState();
//     //* initial state
//     firebaseStorage = FirebaseStorage.instance;

//     var storageRef = firebaseStorage.ref();

//     //* Fetch Data of firebase

//     var imgUrlRef = storageRef.child("images/hacked.png");
//     getImageUrl(imgUrlRef);
//   }

//   //* Download calling
//   void getImageUrl(Reference ref) async {
//     imgURL = await ref.getDownloadURL();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Firebase Download'),
//       ),
//       body: imgURL != ''
//           ? Image.network(
//               imgURL,
//               width: 200,
//             )
//           : const Text('No Data Found'),
//     );
//   }
// }
