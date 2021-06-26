import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class ChatScreen2 extends StatefulWidget {
  @override
  _ChatScreen2State createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  final messageController = TextEditingController();
  String messageText;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() {
    try {
      if (_auth.currentUser != null) {
        loggedInUser = _auth.currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF10101A),
      appBar: AppBar(
        backgroundColor: Color(0xFF10101A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MessagesStream(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF16161C),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Center(
                            child: TextField(
                              cursorColor: Colors.grey,
                              style: TextStyle(color: Colors.white),
                              controller: messageController,
                              onChanged: (value) {
                                setState(() {
                                  messageText = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: InputBorder.none,
                                hintText: 'Type Something.....',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      )),
                      IconButton(
                        splashColor: Color(0xFF16161C),
                        icon: Icon(Icons.send_outlined, color: Colors.white),
                        onPressed: () async {
                          messageController.clear();
                          await _firestore.collection('messages').add({
                            'sender': loggedInUser.email,
                            'text': messageText,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                        },
                      )
                    ]),
              ),
            ]),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color(0xFFFD5630),
                  ),
                ),
              ),
            );
          }
          final messagesss = snapshot.data.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var x in messagesss) {
            final messageText = x['text'];
            final messageSender = x['sender'];
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
            );
            messageWidgets.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: messageWidgets,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String text, sender;
  MessageBubble({@required this.text, @required this.sender});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: (sender == loggedInUser.email)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topLeft: (sender == loggedInUser.email)
                    ? Radius.circular(30)
                    : Radius.zero,
                topRight: (sender == loggedInUser.email)
                    ? Radius.zero
                    : Radius.circular(30)),
            color: (sender == loggedInUser.email)
                ? Color(0xFF16161C)
                : Color(0xFFFD5630),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
