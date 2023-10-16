// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app_using_firebase/auth/google_auth.dart';
import 'package:note_app_using_firebase/constants/img_constant.dart';
import 'package:note_app_using_firebase/constants/json_constant.dart';
import 'package:note_app_using_firebase/model/user_model.dart';
import 'package:note_app_using_firebase/pages/homepage.dart';
import 'package:note_app_using_firebase/pages/user_onboarding/otp_page.dart';
import 'package:note_app_using_firebase/share_pref/share_pref.dart';

import '../../widgets/my_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nameController = TextEditingController();
  var email2Controller = TextEditingController();
  var passSignController = TextEditingController();
  var passConfirmController = TextEditingController();
  var mobileController = TextEditingController();

  bool isHidden = false;
  var mAuth = FirebaseAuth.instance;
  String mVerificationID = '';

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 254, 210, 64),
          Color(0xfffa709a),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 51, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 350,
                child: Lottie.asset(
                  JsonConstants.loginJson,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 85, 85, 85),
                  borderRadius: BorderRadius.circular(31),
                ),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  automaticIndicatorColorAdjustment: true,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(31),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 45),
                  tabs: const [
                    Tab(
                      child: Text(
                        'Existing',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'New',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [loginWidget(), signupWidget()],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  loginWidget() {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: myInputDecoration(
                          mPrefixIcon: Icons.email_outlined,
                          mLabel: 'Email',
                          mHint: 'Email Address'),
                    ),
                    TextField(
                      controller: passController,
                      obscureText: !isHidden,
                      decoration: myInputDecoration(
                        mPrefixIcon: Icons.lock_outline,
                        mLabel: 'Password',
                        mHint: 'Password',
                        mSuffixIcon:
                            isHidden ? Icons.visibility : Icons.visibility_off,
                        onSuffixIconTap: () {
                          isHidden = !isHidden;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 25,
                left: 70,
                child: InkWell(
                  onTap: () async {
                    var auth = FirebaseAuth.instance;
                    var email = emailController.text.toString();
                    var password = passController.text.toString();

                    try {
                      var credSignUp = await auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      print(
                          "Success: User Logged in.. ${credSignUp.user!.uid}");

                      //Shared Preferences..
                      SharePreference.setShared(credSignUp.user!.uid, true);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userID: credSignUp.user!.uid,
                          ),
                        ),
                      );
                    } catch (error) {
                      print('Error is : $error');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 50,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffffb199),
                          Color(0xffff0844),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 182, 88, 0),
                          offset: Offset(0, 0),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {},
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 21,
        ),
        const Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 2,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Or',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                try {
                  await GoogleAuthServices().signupWithGoogle();
                  print('Google Singed in');
                } on FirebaseAuthException catch (e) {
                  print("Error of goolge Auth : $e");
                }
              },
              child: Image.asset(
                ImageConstant.googleImg,
                width: 50,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {},
              child: Image.asset(
                ImageConstant.facebookImg,
                width: 60,
              ),
            )
          ],
        )
      ],
    );
  }

  Stack signupWidget() {
    return Stack(
      children: [
        Container(
          height: 380,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: myInputDecoration(
                    mPrefixIcon: Icons.person,
                    mLabel: 'Name',
                    mHint: 'Enter Your Name'),
              ),
              TextField(
                controller: email2Controller,
                decoration: myInputDecoration(
                    mPrefixIcon: Icons.email_outlined,
                    mLabel: 'Email',
                    mHint: 'Email Address'),
              ),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: myInputDecoration(
                    mPrefixIcon: Icons.phone_android,
                    mLabel: 'Number',
                    mHint: 'Mobile Number'),
              ),
              TextField(
                controller: passSignController,
                obscureText: !isHidden,
                decoration: myInputDecoration(
                  mPrefixIcon: Icons.lock_outline,
                  mLabel: 'Password',
                  mHint: 'Password',
                  mSuffixIcon:
                      isHidden ? Icons.visibility : Icons.visibility_off,
                  onSuffixIconTap: () {
                    isHidden = !isHidden;
                    setState(() {});
                  },
                ),
              ),
              TextField(
                controller: passConfirmController,
                obscureText: !isHidden,
                decoration: myInputDecoration(
                  mPrefixIcon: Icons.lock_outline,
                  mLabel: 'Confirmation Password',
                  mHint: 'Confirmation Password',
                  mSuffixIcon:
                      isHidden ? Icons.visibility : Icons.visibility_off,
                  onSuffixIconTap: () {
                    isHidden = !isHidden;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 15,
          left: 60,
          child: InkWell(
            onTap: () async {
              if (passSignController.text.toString() ==
                  passConfirmController.text.toString()) {
                var email = email2Controller.text.toString();
                var name = nameController.text.toString();
                var mobile = mobileController.text.toString();
                var password = passSignController.text.toString();

                //* Step 1
                mAuth.verifyPhoneNumber(
                  phoneNumber: '+91${mobileController.text.toString()}',
                  verificationCompleted: (PhoneAuthCredential credential) {
                    mAuth.signInWithCredential(credential).then(
                      (value) {
                        print("Login :${value.user!.uid}");
                      },
                    );
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    print("VerificationFailed : ${e.message}");
                  },

                  //* Step 2
                  codeSent: (String verificationId, int? resendToken) {
                    mVerificationID = verificationId;
                    print("Code Send" + mVerificationID);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpPage(
                            email: email,
                            name: name,
                            mobile: mobile,
                            mVerificationID: mVerificationID),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );

                //! For Email Login Process
                // try {
                //   var credId = await mAuth.createUserWithEmailAndPassword(
                //       email: email, password: password);
                //   print('Successfully Sign In In');

                //   //* Set Database using Firebase.

                //   var db = FirebaseFirestore.instance;

                //   db.collection('users').doc(credId.user!.uid).set(UserModel(
                //         email: email,
                //         name: name,
                //         mobNumber: mobile,
                //         id: credId.user!.uid,
                //       ).toMap());
                //   print("User Added: ${credId.user!.uid}");
                // } on FirebaseAuthException catch (error) {
                //   print("Error: ${error.code}");
                // }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 50,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffffb199),
                    Color(0xffff0844),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 182, 88, 0),
                    offset: Offset(0, 0),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
