import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/profileArgument.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';

class messaging extends StatefulWidget {
  @override
  _messagingState createState() => _messagingState();
}

class _messagingState extends State<messaging> {
String userName;
String email;
List<String> curEmails = [];

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot obj = ModalRoute.of(context).settings.arguments;
    userName = obj['name'];
    email = obj['email'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00E5FF),
        automaticallyImplyLeading: false,
        title: Center(child: Text("Messages")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushNamed(context, 'createNewMessage', arguments: obj);
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("Messages").where('People', arrayContainsAny: [email]).snapshots(),
        builder: (context, snapshots) {

          if (!snapshots.hasData) {
            return Text("loading!");
          }
          else {
            if (snapshots.data.documents.length == 0) {
              return Text("No messages!");
            }
            else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, index) {
                  String otherEmail = snapshots.data.documents[index]['To'] != email ? snapshots.data.documents[index]['To']:snapshots.data.documents[index]['From'];
                  if (curEmails.indexOf(otherEmail)!=-1) {
                    return null;
                  }
                  curEmails.add(otherEmail);
                  return FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(image: new NetworkImage("https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png"))
                          ),
                        ),
                       Text(otherEmail),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                    onPressed: () {
                       Navigator.pushNamed(context, 'convo', arguments: email+","+otherEmail);
                    },
                  );
                },
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Feed")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              title: Text("Profile")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload),
              title: Text("Post")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_post_office),
              title: Text("Messages")
          )
        ],
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        onTap: (val) async {
          if (val == 0) {
            Navigator.pushNamed(context, 'feed');
          }
          else if (val == 1) {
            FirebaseUser user = await AuthProvider().getUser();
            String uid = user.uid;
            String url;
            var ref;
            try {
              ref = FirebaseStorage.instance.ref().child(uid);
              url = await ref.getDownloadURL();
            }
            catch (e) {
              ref = null;
              url = null;
            }
            print(ref);
            Navigator.pushNamed(context, '/ProfilePage', arguments: profileArgument(uid, url));
          }
          else if (val == 2) {
            Navigator.pushNamed(context, 'PostPage');
          }
          else {
            //val == 3
          }
        },
      ),
    );
  }
}
