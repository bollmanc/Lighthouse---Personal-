

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_glogin/UI/editProfile.dart';
import 'package:flutter_glogin/UI/profileArgument.dart';
//import 'package:flutter_glogin/utils/database.dart';
//import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String uid;
  String url;


  Widget buildListItem(BuildContext context, DocumentSnapshot doc) {
    return Center(child:
    Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Image.network(url, width: 150, height: 150),
        SizedBox(height: 30),
        Text(doc['name'],style: TextStyle(fontSize: 20),),
        Text(doc['email'],style: TextStyle(fontSize: 20),),
        Text(doc['gradYear'].toString(),style: TextStyle(fontSize: 20),),
        Text(doc['bio'],style: TextStyle(fontSize: 20),),
        SizedBox(height: 50,),
        RaisedButton(
          child: Text("Edit Profile"),
          onPressed: () {
            Navigator.pushNamed(context, 'edit', arguments: uid);
          },
        ),
        SizedBox(height: 10,),
        RaisedButton(
          child: Text("View your posts"),
          onPressed: () {
            Navigator.pushNamed(context, 'myPosts', arguments: doc['uid']);
          },
        )
      ],
    ),);
  }

  Widget buildListItem1(BuildContext context, DocumentSnapshot doc) {
    return Center(child:
    Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(Icons.person),
        SizedBox(),
        Text(doc['name'],style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
        Text(doc['email'],style: TextStyle(fontSize: 20),),
        Text(doc['gradYear'].toString(),style: TextStyle(fontSize: 20),),
        Text(doc['bio'],style: TextStyle(fontSize: 20),),
        SizedBox(height: 50,),
        RaisedButton(
          child: Text("Edit Profile"),
          onPressed: () {
            Navigator.pushNamed(context, 'edit', arguments: uid);
          },
        ),
        SizedBox(height: 10,),
        RaisedButton(
          child: Text("View your posts"),
          onPressed: () {
            Navigator.pushNamed(context, 'myPosts',arguments: this.uid);
          },
        )
    ]
    )
    );
  }



  @override
  Widget build(BuildContext context) {
    profileArgument obj = ModalRoute.of(context).settings.arguments;
    uid = obj.uid;
    url = obj.url;
   return url == null?Scaffold(
          body:
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(top: 15),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
              Center(
                child: Text("Profile Page", style: GoogleFonts.lobster(
                    color: Color(0xFFFFEA00),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold)),
              ),
                StreamBuilder(
                  stream: Firestore.instance.collection("Users").where(
                      'uid', isEqualTo: this.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading");
                    }
                    else {
                      return buildListItem1(context, snapshot.data.documents[0]);
                    }
                  },
                ),

              ],
            ),
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
       currentIndex: 1,
       selectedItemColor: Colors.blue,
       unselectedItemColor: Colors.blueGrey,
       onTap: (val) async {
         if (val == 0) {
           Navigator.popUntil(context, ModalRoute.withName('feed'));
         }
         else if (val == 1) {

         }
         else if (val == 2) {
           Navigator.pushNamed(context, 'PostPage');
         }
         else {
           //val == 3
           QuerySnapshot qs = await Firestore.instance.collection("Users").where('uid', isEqualTo: uid).getDocuments();
           Navigator.pushNamed(context, 'messagingHome',arguments: qs.documents[0]);
         }
       },
     ) ,
      ):Scaffold(
          body:
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(top: 15),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance.collection("Users").where(
                      'uid', isEqualTo: this.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading");
                    }
                    else {
                      return buildListItem(context, snapshot.data.documents[0]);
                    }
                  },
                ),

              ],
            ),
          )
      );


  }
}


