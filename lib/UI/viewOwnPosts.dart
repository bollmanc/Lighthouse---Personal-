import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';



class myPosts extends StatefulWidget {
  @override
  _myPosts createState() => _myPosts();
}

class _myPosts extends State<myPosts> {

  String uid;




  @override
  Widget build(BuildContext context){
    uid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Posts"),
        //backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
      ),
      body:
      StreamBuilder(
        stream: Firestore.instance.collection("Posts").where('Seller_uid', isEqualTo: this.uid).snapshots(),
        builder: (context,snapshot)  {
          if (!snapshot.hasData) {
            return Text("Loading...");
          }
          else if (snapshot.data.documents.length==0) {
            return Text("You haven't posted yet!");
          }
          else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,index) {
                  return FlatButton(
                    child: Card(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(snapshot.data.documents[index]['ProductName'],
                                  style: TextStyle(
                                      fontSize: 25
                                  )),
                              Image.network(snapshot.data.documents[index]['imageURL'][0],
                                height: 100,
                                width: 100,
                              ),
                              snapshot.data.documents[index]['maxBid']==0?Text("No bids yet"):Text("Max Bid: " + snapshot.data.documents[index]['maxBid'].toString()),
                              Text("Number of bidders: " + snapshot.data.documents[index]['map'].keys.length.toString())

                            ],
                          ),
                        )
                    ),
                    onPressed: () async {

                      String docId = snapshot.data.documents[index]['DocId'];
                      Map map = snapshot.data.documents[index]['map'];
                      Map new_map = new Map();
                      List l;
                      String user_id;
                      String name;
                     for (var id in map.keys) {
                        user_id = id;
                        name = await getName(user_id);
                       l = map[id];
                       new_map[name]=l;
                     }
                      product_and_bids obj = product_and_bids(docId, new_map, snapshot.data.documents[index]['ProductName']);
                      Navigator.pushNamed(context, 'ownProductInfo', arguments: obj);

                    }
                    ,
                  );
                }
            );

          }
        },
      ),
    );
  }

  getName(String user_id) async {
    QuerySnapshot qs = await Firestore.instance.collection("Users").getDocuments();
    List<DocumentSnapshot> docs = qs.documents;
    for (int i = 0; i < docs.length; ++i) {
      if (docs[i]['uid']==user_id) {
        return docs[i]['name'];
      }
    }
  }


}

class product_and_bids {
  String docId;
  Map map;
  String productName;
  product_and_bids(String id, Map m, String n) {
    this.docId = id;
    this.map = m;
    this.productName = n;
  }
}