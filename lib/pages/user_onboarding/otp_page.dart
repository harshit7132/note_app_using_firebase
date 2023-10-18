// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app_using_firebase/constants/img_constant.dart';
import 'package:note_app_using_firebase/model/user_model.dart';
import 'package:note_app_using_firebase/pages/user_onboarding/login_page.dart';
import 'package:note_app_using_firebase/widgets/my_widget.dart';

class OtpPage extends StatefulWidget {
  String email;
  String name;
  String mobile;
  String password;

  String mVerificationID;

  OtpPage(
      {super.key,
      required this.email,
      required this.name,
      required this.mobile,
      required this.mVerificationID,
      required this.password});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var mobileController = TextEditingController();
  var otp1Controller = TextEditingController();
  var otp2Controller = TextEditingController();
  var otp3Controller = TextEditingController();
  var otp4Controller = TextEditingController();
  var otp5Controller = TextEditingController();
  var otp6Controller = TextEditingController();
  late FirebaseAuth firebaseAuth;

  @override
  void initState() {
    super.initState();
    authFirebaseInit();
  }

  void authFirebaseInit() {
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TextField(
          //   controller: mobileController,
          // ),
          // ElevatedButton(
          //     onPressed: () {
          //       //* Step 1
          //       firebaseAuth.verifyPhoneNumber(
          //         phoneNumber: '+91${mobileController.text.toString()}',
          //         verificationCompleted: (PhoneAuthCredential credential) {
          //           firebaseAuth.signInWithCredential(credential).then(
          //             (value) {
          //               print("Login :${value.user!.uid}");
          //             },
          //           );
          //         },
          //         verificationFailed: (FirebaseAuthException e) {
          //           print("VerificationFailed : ${e.message}");
          //         },
          //         codeSent: (String verificationId, int? resendToken) {
          //           mVerificationID = verificationId;
          //           print("Code Send" + mVerificationID);
          //         },
          //         codeAutoRetrievalTimeout: (String verificationId) {},
          //       );
          //     },
          //     child: Text('Send OTP')),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 254, 210, 64),
                  Color(0xfffa709a),
                  Color.fromARGB(255, 255, 82, 134),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: const EdgeInsets.only(
                      top: 100,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            ImageConstant.otpImg,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const Text(
                          'OTP Verification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      'Verification',
                      style: GoogleFonts.rougeScript(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      'We have send OTP on your register mobile number',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //* OTP
                  otpMethod(context)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          confirmPassword(context),
          const SizedBox(
            height: 40,
          ),
          sendAgain()
        ],
      ),
    );
  }

//* OTP Repeat
  Row sendAgain() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t receive OTP?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            'Resend again',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xfffa709a),
            ),
          ),
        )
      ],
    );
  }

//* Continue
  Row confirmPassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            '15 Sec Left',
            style:
                GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        InkWell(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(30),
          ),
          onTap: () async {
            if (otp1Controller.text.isNotEmpty &&
                otp2Controller.text.isNotEmpty &&
                otp3Controller.text.isNotEmpty &&
                otp4Controller.text.isNotEmpty &&
                otp5Controller.text.isNotEmpty &&
                otp6Controller.text.isNotEmpty) {
              var otp = otp1Controller.text.toString() +
                  otp2Controller.text.toString() +
                  otp3Controller.text.toString() +
                  otp4Controller.text.toString() +
                  otp5Controller.text.toString() +
                  otp6Controller.text.toString();

              print("OTP : ${otp}");

              var credential = PhoneAuthProvider.credential(
                  verificationId: widget.mVerificationID, smsCode: otp);
              print("credential : ${credential}");
              try {
                var credId =
                    await firebaseAuth.signInWithCredential(credential);

                var db = FirebaseFirestore.instance;

                db.collection('users').doc(credId.user!.uid).set(UserModel(
                        email: widget.email,
                        name: widget.name,
                        mobNumber: widget.mobile,
                        id: credId.user!.uid,
                        password: widget.password)
                    .toMap());
                print("User Added: ${credId.user!.uid}");
              } on FirebaseAuthException catch (e) {
                print("Error is " + e.toString());
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xfffa709a),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Continue',
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white)
              ],
            ),
          ),
        ),
      ],
    );
  }

//* OTP Method
  Row otpMethod(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 40,
          height: 50,
          color: Colors.white,
          child: TextField(
            controller: otp1Controller,
            autofocus: true,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: myInputDecoration(mLabel: '', mHint: ''),
          ),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.white,
          child: TextField(
            controller: otp2Controller,
            autofocus: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: myInputDecoration(mLabel: '', mHint: ''),
          ),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.white,
          child: TextField(
            controller: otp3Controller,
            autofocus: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: myInputDecoration(mLabel: '', mHint: ''),
          ),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.white,
          child: TextField(
            controller: otp4Controller,
            autofocus: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: myInputDecoration(mLabel: '', mHint: ''),
          ),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.white,
          child: TextField(
            controller: otp5Controller,
            autofocus: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: myInputDecoration(mLabel: '', mHint: ''),
          ),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.white,
          child: TextField(
            controller: otp6Controller,
            autofocus: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: myInputDecoration(mLabel: '', mHint: ''),
          ),
        ),
      ],
    );
  }
}
