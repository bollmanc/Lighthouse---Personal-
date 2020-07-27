import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/ownProductInfo.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';


class sell extends StatefulWidget {

  @override
  _sellState createState() => _sellState();
}

class _sellState extends State<sell> {

  @override
  Widget build(BuildContext context) {
    sellingInfo obj = ModalRoute.of(context).settings.arguments;
    String docId = obj.docId;
    String buyer_uid = obj.buyer_id;
    String buyer_name = obj.buyer_name;
    int maxBid = obj.buyer_maxBid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Sale"),
      ),
      body:StreamBuilder(
        stream: Firestore.instance.collection("Posts").where('DocId', isEqualTo: docId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          else {
            return Column(
              children: <Widget>[
                Image.network(snapshot.data.documents[0]['imageURL'], height: 100, width: 100,),
                Center(
                  child: Row(
                    children: <Widget>[Expanded(
                      child: Text(snapshot.data.documents[0]['ProductName'],
                      style: TextStyle(
                        fontSize: 25
                      ),),
                    )]
                  ),
                ),
                SizedBox(height: 30,width: 30),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Description: " + snapshot.data.documents[0]['ProductDescription'],
                      style: TextStyle(fontSize: 15)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Buyer: " + buyer_name, style: TextStyle(fontSize: 15),),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Selling Price: " + maxBid.toString(),style: TextStyle(fontSize: 15),),
                    )
                  ],
                ),
                RaisedButton(
                  child: Text("Confirm Sale"),
                  onPressed: ()  async {

                  },
                )
              ],
            );
          }
        },
      )

    );

  }
}
