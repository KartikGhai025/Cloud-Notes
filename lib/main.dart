import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/noteScreen.dart';
import 'otpscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Note App',
        theme: ThemeData(
          primarySwatch: Colors.blue,

        ),
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home':(context)=> LoginScreen()
        },
    )
    ;
  }
}
