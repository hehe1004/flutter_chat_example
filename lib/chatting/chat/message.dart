import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          //스트림에 접근하기 전에
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
            reverse: true,
            //메세지 순서
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              return ChatBubbles(
                  chatDocs[index]['text'],
                  chatDocs[index]['userId'].toString() == user!.uid,
                  chatDocs[index]['userName'].toString(),
                  chatDocs[index]['userImage']
              );

            });
      },
    );
  }
}
