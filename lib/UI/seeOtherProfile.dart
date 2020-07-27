import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class seeOtherProfile extends StatelessWidget {
  String uid;
  
  @override
  Widget build(BuildContext context) {
  uid = ModalRoute.of(context).settings.arguments;  
    return Scaffold(
      appBar: AppBar(title: Text("Prospective Buyer's Profile")),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Users').where('uid', isEqualTo: this.uid).snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          }
          return Center(
            child: Column(
              children: <Widget>[
                  Text(snapshot.data.documents[0]['name']),
                  Text(snapshot.data.documents[0]['email']),
                  Text(snapshot.data.documents[0]['bio']),
              ],
            ),
          );
        },
      )
    );
  }
}
