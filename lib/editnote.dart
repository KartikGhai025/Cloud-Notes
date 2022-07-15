import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class EditNote extends StatefulWidget {
  String text;
  String id;
  EditNote({Key? key, required this.text, required this.id}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState(text: text, id: id);
}

class _EditNoteState extends State<EditNote> {
  String text;
  String id;

  _EditNoteState({required this.text, required this.id});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController =
    TextEditingController(text: text);
    String newtext = _noteController.text;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    newtext = value;
                  },
                  maxLines: 4,
                  controller: _noteController,
                  decoration: const InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {

                  await FirebaseFirestore.instance
                      .collection('note')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('notes')
                      .doc(id)
                      .update({'note': _noteController.text});
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
