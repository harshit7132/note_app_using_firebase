import 'package:flutter/material.dart';
import '../App_folder/Note_app/note_app.dart';
import '../App_folder/Home_page/home_page.dart';
import 'account_page.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    var pageViewList = [ const HomePage(),NoteApp(userId:widget.userId), AccountPage(userId: widget.userId,)];

    return Scaffold(
      body:pageViewList[selectedPage],

      bottomNavigationBar:BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        unselectedLabelStyle: const TextStyle(color: Colors.black54),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(label: "Home",icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Note App",icon: Icon(Icons.note_add)),
          BottomNavigationBarItem(label: "Account",icon: Icon(Icons.person)),
        ],
        currentIndex: selectedPage,
        onTap:(value){
          setState(() {
            selectedPage = value;
          });
        },
      ),
    );
  }
}
