import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/profile.dart';
import 'package:flutter_glogin/UI/profileArgument.dart';
import 'package:flutter_glogin/UI/viewOwnPosts.dart';

class ownProductInfo extends StatefulWidget {

  @override
  _ownProductInfoState createState() => _ownProductInfoState();
}

class _ownProductInfoState extends State<ownProductInfo> {





  getUID(String name, BuildContext context) async {
    QuerySnapshot qs = await Firestore.instance.collection("Users").where("name", isEqualTo: name).getDocuments();
    List<DocumentSnapshot> l = qs.documents;
    return l[0]['uid'];
  }





  @override
  Widget build(BuildContext context) {
    product_and_bids obj = ModalRoute.of(context).settings.arguments;
    String docId = obj.docId;
    Map map = obj.map;
    String prodName = obj.productName;
    int numBidders = map.keys.length;
    List<Widget> list = [];
    List<String> names=[];
    int maxBid;
    String bidder;
    List bids;
    for (int i = 0; i < numBidders; ++i) {
     bidder = map.keys.elementAt(i);
     names.add(bidder);
     bids = map[bidder];
     bids.sort();
     maxBid = bids[bids.length-1];
          list.add(
            FlatButton(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Bidder: "+ bidder ),
                  ),
                  Expanded(
                    child: Text("Max bid: " + maxBid.toString()) ,
                  ),
                  RaisedButton(
                    child: Text("Sell"),
                    onPressed: () async {
                      sellingInfo obj =  await sellingInfo(docId, await getUID(names[i], context), names[i], maxBid);
                        Navigator.pushNamed(context, 'sell', arguments: obj);
                    },
                  )
                ],
              ),
              onPressed: () async {
                  print(names[i]);
                    String uid = await getUID(names[i], context);
                    Navigator.pushNamed(context, 'seeOtherProfile', arguments:uid);
              },
            )
          );
    }

    String uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(prodName+" Product Information"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: list.length==0?[Text("No bidders yet!")]:list,
      ),
    );
  }
}

class sellingInfo {
  String docId;
  String buyer_id;
  String buyer_name;
  int buyer_maxBid;

  sellingInfo(String doc, String uid, String name, int bid) {
    this.docId = doc;
    this.buyer_id = uid;
    this.buyer_name = name;
    this.buyer_maxBid = bid;
  }


}



