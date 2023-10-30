import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_app_using_firebase/firebase_options.dart';
import 'Screen_view/home_screen.dart';
import 'Screen_view/welcome_screen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
    );
    runApp(const FlutterFireSeries());
}

class FlutterFireSeries extends StatelessWidget {
  const FlutterFireSeries({super.key});

  @override
  Widget build(BuildContext context) {
   return  MaterialApp(
     debugShowCheckedModeBanner: false,
     home:(FirebaseAuth.instance.currentUser != null) ?
      HomeScreen(userId:FirebaseAuth.instance.currentUser!.uid,) :const WelcomeScreen(),
   );
  }
}
