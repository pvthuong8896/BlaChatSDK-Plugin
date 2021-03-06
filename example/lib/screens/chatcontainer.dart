import 'package:flutter/material.dart';
import 'chatcontent.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'dart:async';
import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:bla_chat_sdk/EventType.dart';
import 'package:bla_chat_sdk/BlaChannel.dart';


class ChatContainer extends StatefulWidget {

  String conversationID;

  String myID;


  ChatContainer(this.conversationID, this.myID);

  @override
  State createState() => new _ChatContainerState(conversationID, myID);

}


class _ChatContainerState extends State<ChatContainer> {

  String conversationID;

  String myID;

  bool otherUserTyping = false;

  _ChatContainerState(
      this.conversationID,
      this.myID);


  void initState(){
    super.initState();
    listenTypingEvent();
  }

  void listenTypingEvent() async {

    await BlaChatSdk.instance.addChannelListener(new ChannelListener(
        onTyping: (BlaChannel channel, BlaUser user, EventType type) {
          print("onTyping in message screen");
        }
    ));
    await BlaChatSdk.instance.addMessageListener(new MessageListener(
      onNewMessage: (message) {
        print("have new message in message screen: " + message.content);
      }
    ));
//    Blachat.instance.addTypingListener((String channelID, String userID, int time, bool isTyping) {
//      if (mounted){
//        if (channelID == conversationID && DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 - time < 5000 ) {
//          if (isTyping){
//            if (timer != null) timer.cancel();
//            timer = new Timer(const Duration(milliseconds: 5000), (){
//              if (mounted) {
//                setState(() {
//                  otherUserTyping = false;
//                });
//              }
//            });
//          }
//          setState(() {
//            otherUserTyping = isTyping;
//          });
//        }
//      }
//    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Chat',
              ),
              Visibility(
                visible: otherUserTyping,
                child: Text(
                  'people is typing...',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: new ChatContent(conversationID, myID),
        )
    );
  }
}