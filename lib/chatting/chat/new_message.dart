import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  //메세지 보내면 보낸창에 보낸메세지 안남게
  final _controller = TextEditingController();

  var _userEnterMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();


    final user = FirebaseAuth.instance.currentUser;

    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    //get 메소드 반환값 퓨터라 await, async 추가
    //보내기 버튼으로 데이터 추가
    FirebaseFirestore.instance
        .collection('chat')
        .add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userId': user!.uid,
      'userName': userData.data()!['userName'],
      'userImage' : userData.data()!['picked_image']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              //텍스트 필드 자동 줄바꿈
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'send a message...',
              ),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                  //메세지가 있을때 보내기 버튼 활성화
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage
                .trim()
                .isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
