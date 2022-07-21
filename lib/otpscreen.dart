import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import 'noteScreen.dart';

enum MobileVerificationState {
  mobile_form_state,
  otp_form_state,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.mobile_form_state;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null){
        await FirebaseFirestore.instance
            .collection('note')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('properties');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NoteStreamData()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          keyboardType: TextInputType.phone,
          controller: phoneController,
          decoration: const InputDecoration(
            hintText: "Phone Number",
          ),
        ),
       const SizedBox(
          height: 16,
        ),
        MaterialButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });

            await _auth.verifyPhoneNumber(
              phoneNumber: "+91${phoneController.text}",
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });

              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                _scaffoldKey.currentState!.showSnackBar(
                    SnackBar(content: Text('${verificationFailed.message}')));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.otp_form_state;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          color: Colors.green,
          textColor: Colors.white,
          child: Text("SEND"),
        ),
       const Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
       const Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        MaterialButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
            PhoneAuthProvider.credential(
                verificationId: "${verificationId}", smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("VERIFY"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ?  Center(
            child: CircularProgressIndicator(),
          )
              : currentState == MobileVerificationState.mobile_form_state
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
