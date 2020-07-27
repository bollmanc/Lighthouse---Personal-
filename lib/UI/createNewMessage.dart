import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';

class createNewMessage extends StatefulWidget {
  @override
  _createNewMessageState createState() => _createNewMessageState();
}

class _createNewMessageState extends State<createNewMessage> {
  String uid;
  String email;
  String init = "Select a user!";
  String current;
  String to;
  PageController _controller;
  List<DocumentSnapshot> docs;
  int button = -1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController;
  @override
  void initState() {
    super.initState();
    current = init;
    to = null;
    textController = TextEditingController(text:"");
  }


  @override
  Widget build(BuildContext context) {
    DocumentSnapshot obj = ModalRoute.of(context).settings.arguments;
    uid = obj['uid'];
    email = obj['email'];
    return Scaffold(
      appBar: AppBar(
        title:Text("Creating a New Message"),
      ),
      body: PageView(
        controller: _controller,
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection("Users").snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                  itemCount: snapshot.data.documents.length + 1,
                  itemBuilder: (context, index) {
                  if (index < snapshot.data.documents.length) {
                    return snapshot.data.documents[index]['email']!=email?FlatButton(
                      color: index==button?Colors.blue:Colors.black,
                      child: Row(
                        children: <Widget>[
                          Text("Email: "+snapshot.data.documents[index]['email'], style: TextStyle(color: Colors.white),),
                          SizedBox(width: 40),
                          Text("Name: "+snapshot.data.documents[index]['name'], style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          button = index;
                          to = snapshot.data.documents[button]['email'];
                        });
                      },
                    ):SizedBox(height: 1);
                    }
                  else {
                    return Row(
                      children: <Widget>[
                        SizedBox(height: 100),
                        Text("Swipe to the left to type message!"),
                        SizedBox(width: 50,),
                        Icon(Icons.arrow_right)
                      ],
                    );
                    }
            });
            },
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(12),
                  height: 120,
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "Type message here!",
                      helperText: to==null?"":"Sending to " + to,
                    ),
                    minLines: 5,
                    maxLines: 10,
                    validator: (text) {
                      if ((text==null) || (text.length == 0) || (to==null))  {
                        return "Enter message and select a recipient!";
                      }
                      return null;
                    },
                  ),
                ),
                RaisedButton(
                  child: Text("Submit") ,
                  onPressed: () async {
                    if ((_formKey.currentState.validate()) && (to!=null))  {
                      String from = email;
                      String text = textController.text;
                     await DatabaseService(uid).addMessage(to, from, text);
                     Navigator.pop(context, obj);
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
