import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.userName, this.userImage,
      {Key? key})
      : super(key: key);

  final String message;
  final String userName;
  final bool isMe;
  final String userImage;

  //외부에서 값 받아와야함으로 생성자에 값 추가

  @override
  Widget build(BuildContext context) {
    return Stack(
        //이미지를 쳇버블 위에 올릴려고 스택 위젯 사용
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    10,
                    45,
                    0,
                  ),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 20),
                    backGroundColor: Colors.blue,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(45, 10, 0, 0),
                  child: ChatBubble(
                    clipper:
                        ChatBubbleClipper8(type: BubbleType.receiverBubble),
                    backGroundColor: Color(0xffE7E7ED),
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: !isMe
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            message,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              //chatbubble 이라는 라이브러리를 사용함으로 직접 만든 위젯은 주석
              /* Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey : Colors.blue,
              // borderRadius: BorderRadius.circular(12),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0)
              ),
            ),
            width: 145,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              message,
              style: TextStyle(color: isMe ? Colors.black : Colors.white),
            ),
          ),*/
            ],
          ),
          Positioned(
          top:0,
              right: isMe? 5: null,
              left:  isMe? null : 5,
              child: CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              ),)
        ]
        );
  }
}
