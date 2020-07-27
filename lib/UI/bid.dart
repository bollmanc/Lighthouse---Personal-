import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';



class Bid extends StatefulWidget {

  @override
  _BidState createState() => _BidState();
}

class _BidState extends State<Bid> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController userBid;

  @override
  void initState() {
    super.initState();
    userBid = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bidding Page"),),
      body: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: Firestore.instance.collection("Posts").where('DocId', isEqualTo: ModalRoute.of(context).settings.arguments).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Column(
                      children: <Widget>[
                        Image.network(snapshot.data.documents[0]['imageURL'][0],
                        width: 100,
                        height: 100),
                        Text(snapshot.data.documents[0]['ProductName']),
                        Text(snapshot.data.documents[0]['SellerName']),
                        snapshot.data.documents[0]['maxBid']==0?Text("No bid yet"):Text((snapshot.data.documents[0]['maxBid']).toString()),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               TextFormField(
                                 controller: userBid,
                                   decoration:
                                  InputDecoration(
                                    hintText: 'Enter a bid',
                                  ),
                                validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                if (int.parse(value)<= 0) {
                                      return 'Must be a postive value';
                                  }
                                return null;
                              }),
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: RaisedButton(
                                onPressed: () async {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState.validate()) {
                                  FirebaseUser user = await AuthProvider().getUser();
                                  await DatabaseService(snapshot.data.documents[0]['Seller_uid']).addBid(ModalRoute.of(context).settings.arguments, int.parse(userBid.text), user.uid);
                                  Navigator.pop(context);
                                }

                                },
                              child: Text('Submit'),
                            ),
                            )
                            ],
                          ),
                        ),
                      ],
                    );
                }
              },
            )
          ],
        ),
      ),

    );
  }
}
