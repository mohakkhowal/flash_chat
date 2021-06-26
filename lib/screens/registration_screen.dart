import 'package:flutter/material.dart';
import 'package:flash_chat/components/NamedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String email, password;
  bool showSpinner = false;
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
            Navigator.pop(context);
          },
        ),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(valueColor:new AlwaysStoppedAnimation<Color>(Colors.orange),),
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: messageTextController,
                obscureText: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              NamedButton(
                title: 'Register',
                colorr: Colors.orange,
                ontap: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  // print(email);
                  // print(password);
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, 'chat');
                    }
                    messageTextController.clear();
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
