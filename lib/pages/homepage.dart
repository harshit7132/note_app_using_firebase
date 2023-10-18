// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app_using_firebase/model/note_model.dart';
import 'package:note_app_using_firebase/pages/profile/profile_page.dart';
import 'package:note_app_using_firebase/pages/user_onboarding/login_page.dart';
import 'package:note_app_using_firebase/share_pref/share_pref.dart';

class HomePage extends StatefulWidget {
  String userID;

  HomePage({super.key, required this.userID});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseFirestore db;
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var titleUpdateController = TextEditingController();
  var descUpdateController = TextEditingController();
  var searchController = TextEditingController();

  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: const Color(0xfffa709a),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: widget.userID),
                ),
              );
            },
            icon: const Icon(
              Icons.person_2_rounded,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              onPressed: () async {
                SharePreference.setShared('', false);
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: db
            .collection('users')
            .doc(widget.userID)
            .collection('notes')
            .where('title',
                isGreaterThanOrEqualTo: searchController.text.toLowerCase())
            .where('title',
                isLessThanOrEqualTo:
                    searchController.text.toLowerCase() + '\uf8ff')
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: TextField(
                    autofocus: !isFirst,
                    onChanged: (value) async {
                      if (isFirst) {
                        isFirst = false;
                      }
                      var searchQuery = await db
                          .collection('Notes')
                          .where('title',
                              isGreaterThanOrEqualTo: value.toLowerCase())
                          .where('title',
                              isLessThanOrEqualTo:
                                  value.toLowerCase() + '\uf8ff')
                          .get();

                      setState(() {
                        searchQuery.docs.map((e) => e.data()).toList();
                      });

                      // print('mPRint ' + mPrint.toString());
                    },
                    // autofocus: true,
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Notes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      //* Yaha se Model me data ko laa kar rahe h...
                      var model =
                          NoteModel.fromJson(snapshot.data!.docs[index].data());
                      return InkWell(
                        onTap: () {
                          titleUpdateController.text = model.title.toString();
                          descUpdateController.text = model.body.toString();
                          updateNote(context, snapshot, index);
                        },
                        child: ListTile(
                          title: Text('${model.title}'),
                          subtitle: Row(
                            children: [
                              Text('${model.body}'),
                              const SizedBox(width: 10),
                              Text('${model.timer!.toDate()}')
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () {
                              db
                                  .collection('users')
                                  .doc(widget.userID)
                                  .collection('notes')
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete()
                                  .then((value) {});
                            },
                            child: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tabBTN(context);
          //* Init State to use add Data
          // db
          //     .collection('Notes')
          //     .add(NoteModel(title: 'title', body: 'desc').toJson())
          //     .then(
          //   (value) {
          //     print(value.id);
          //   },
          // );

          //* Direct Add Data
          // var db = FirebaseFirestore.instance;

          // db.collection('student').add(
          //   {'name': 'Raj', 'Class': '10th', 'Sec': 'B'},
          // ).then(
          //   (value) {
          //     print(value.id);
          //   },
          // );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  //* Update Note
  Future<dynamic> updateNote(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            children: [
              const Text('Update Data'),
              TextField(
                controller: titleUpdateController,
                decoration: InputDecoration(
                  hintText: 'Enter Your title',
                  label: const Text('Title'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: descUpdateController,
                decoration: InputDecoration(
                  hintText: 'Enter Your title',
                  label: const Text('Title'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await db
                        .collection('users')
                        .doc(widget.userID)
                        .collection('notes')
                        .doc(snapshot.data!.docs[index].id)
                        .update(
                          NoteModel(
                            title: titleUpdateController.text.toString(),
                            body: descUpdateController.text.toString(),
                          ).toJson(),
                        );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: Colors.amber.shade100,
                  ),
                  child: const Text('Update'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

//* Show Bottom Sheet
  tabBTN(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            children: [
              const Text(
                'Add Data',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 11,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Your title',
                  label: const Text('Title'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Desc',
                  label: const Text('Desc'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var title = titleController.text.toString();
                    var desc = descController.text.toString();
                    await db
                        .collection('users')
                        .doc(widget.userID)
                        .collection('notes')
                        .add(NoteModel(title: title, body: desc).toJson());
                    //   .then(
                    // (value) {
                    //   print(value.id);
                    // },
                    // );
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    padding: const EdgeInsets.all(5),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}



//FutureBuilder(
          // future: db.collection('Notes').get(),
          // builder: (_, snapshot) {
          //   if (snapshot.connectionState == ConnectionState.waiting) {
          //     return Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   } else if (snapshot.hasError) {
          //     return Center(
          //       child: Text(snapshot.error.toString()),
          //     );
          //   } else if (snapshot.hasData) {
          //     return ListView.builder(
          //       itemCount: snapshot.data!.docs.length,
          //       itemBuilder: (_, index) {
          //         //* Yaha se Model me data ko laa kar rahe h...
          //         var model =
          //             NoteModel.fromJson(snapshot.data!.docs[index].data());
          //         return ListTile(
          //           title: Text('${model.title}'),
          //           subtitle: Text('${model.body}'),
          //         );
          //       },
          //     );
          //   }

          //   return Container();
          // }),