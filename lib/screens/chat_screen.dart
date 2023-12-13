import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _incrementCounter() {
    FirebaseFirestore.instance
        .collection('Chats/jE7cDpXzV4hJgebJbELZ/Messages')
        .add({'text': 'added from app'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 5),
                    Text('Logout'),
                  ]),
                ),
                value: 'logout',
              )
            ],
            icon: Icon(Icons.more_vert_rounded),
            onChanged: (id) {
              if (id == 'logout') FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Chats/jE7cDpXzV4hJgebJbELZ/Messages')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data?.docs;
          if (documents == Null) return (Center(child: Text("No, chat")));
          return ListView.builder(
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(10),
              child: Text(documents[index]['text']),
            ),
            itemCount: documents!.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
