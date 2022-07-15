import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/addNote.dart';
import 'package:notes_app/editnote.dart';
import 'package:notes_app/otpscreen.dart';

class NoteStreamData extends StatefulWidget {
  const NoteStreamData({Key? key}) : super(key: key);

  @override
  State<NoteStreamData> createState() => _BuilderPropertyPage();
}

class _BuilderPropertyPage extends State<NoteStreamData> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('note')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
print(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                 await FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, 'home');
              }),
          title: const Text('Note App'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNote()));
              },
              child: const Icon(Icons.add),
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        child: StreamBuilder<QuerySnapshot>(
          stream: usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: const CircularProgressIndicator());
            }

            return GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(15)),
                              child:  Center(
                                  child: Text(' ${data['note'].toString().substring(0,5)}',
                              ))),
                          Positioned(
                            bottom: -10,
                            left: 105,
                            child: IconButton(
                              onPressed: () async {
                                //   print(index);
                                await FirebaseFirestore.instance
                                    .collection('note')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('notes')
                                    .doc(document.id)
                                    .delete();
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 105,
                            child: IconButton(
                              onPressed: () async {
                                print(document.id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditNote(
                                              text: data['note'],
                                              id: document.id.toString(),
                                            )));
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

