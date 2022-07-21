import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {

  AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {


  final TextEditingController _noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  maxLines: 4,
                  controller: _noteController,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
              //    print(_noteController.text);


                  FirebaseFirestore.instance
                      .collection('note')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('notes')
                      .add({'note': _noteController.text});
                  Navigator.pop(context);
                },
                child: Text('Add Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
