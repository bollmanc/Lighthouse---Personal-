

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/bid.dart';
import 'package:flutter_glogin/UI/post.dart';
import 'package:flutter_glogin/UI/profile.dart';
import 'package:flutter_glogin/UI/profileArgument.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buyNow.dart';
import 'editProfile.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_glogin/utils/firebase_auth.dart';

/*
void main (){
  runApp(MaterialApp(
    home: HomePage(),
    theme: themeData,
    ));
}
*/

final ThemeData themeData = ThemeData(
  canvasColor: Colors.lightGreenAccent,
  accentColor: Colors.redAccent, 
);


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String current = 'Default';
  String current2 = 'Categories';
   bool orig;
   bool alphabetical;
   bool reverseOrig;
   bool noBids;
   bool fifty;
   bool lhundred;
   bool gehundred;
   bool searching;
   bool categories;
   String search = '';
   String limiter='';
   List<String> choices = [];
  List<String> choices2 = ['Categories','Men\'s Clothing', 'Women\'s Clothing', 'Accessories', 'Room Decoration', 'Kitchen', 'Bedroom', 'Textbooks', 'Other'];
   @override
  void initState() {
     super.initState();
     orig = true;
     alphabetical = false;
     reverseOrig = false;
     noBids = false;
     fifty = false;
     lhundred = false;
     gehundred = false;
     searching = false;
     categories = false;
     choices.add('Default');
     choices.add('Alphabetical');
     choices.add('Oldest First');
     choices.add('No Bids');
     choices.add("Max Bid < 50");
     choices.add("Max Bid < 100");
     choices.add("Max Bid >= 100");
   }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00E5FF),
        centerTitle: true,
        title: Text("lighthouse", style: GoogleFonts.lobster(
            color: Colors.white,
            fontSize: 26.0,
            fontWeight: FontWeight.bold)),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: (){
              AuthProvider().logOut();
            },
          ),
        ]
      ),
      body:
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: (Colors.white),
        ),
        child: ListView(
          padding: EdgeInsets.only(right: 10, left: 10),
          children: <Widget>[
            Container(
              height: 40,
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget> [
                categories==true?Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("Viewing "+ current2, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),),
                ):Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("Viewing All Posts ", style: TextStyle(
                      fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),),
                ),
                SizedBox(width: 40,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        icon: Icon(Icons.search)
                    ),
                    onChanged: (val) {
                      limiter = '';
                      if (val.length > 0) {
                        setState(() {
                          int charCode = val[val.length-1].codeUnitAt(0);
                          limiter = val.substring(0,val.length-1) + String.fromCharCode(charCode+1);
                          searching = true;
                          search = val;
                        });
                      }
                      else {
                        setState(() {
                          searching = false;
                        });
                      }
                    },
                  ),
                ),
             ],
            ),
            ),
            searching==true?StreamBuilder(
              stream: Firestore.instance.collection("Posts").where('ProductName', isGreaterThanOrEqualTo: search).where('ProductName', isLessThan: limiter).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                } else {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Card(
                              color: Colors.blue,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {

                                            },
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },
            ):Container(),
            ((searching==false)&&(categories==true))?StreamBuilder(
              stream: Firestore.instance.collection("Posts").where('category',isEqualTo:current2).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                ),
                              ),
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },
            ):Container(),
            ((orig==true) && (searching==false) && (categories==false))?StreamBuilder(
              stream: Firestore.instance.collection("Posts").orderBy('time',descending: true).snapshots(),
              builder: (context,snapshot)  {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: Colors.white,
                            child: Card(
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(snapshot.data.documents[index]['ProductName'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold
                                                )),
                                            snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                          ],
                                        ),
                                        SizedBox(
                                          height: 200,
                                          child: ListView(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            children: ims,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            RaisedButton(
                                              child: Text("Buy Now"),
                                              onPressed: () {},
                                            ),
                                            RaisedButton(
                                              child: Text("Bid"),
                                              onPressed: () {
                                                Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },

            ):SizedBox(height: 1),
            ((reverseOrig==true) && (searching==false) && (categories==false))?  StreamBuilder(
              stream: Firestore.instance.collection("Posts").orderBy('time',descending: false).snapshots(),
              builder: (context,snapshot)  {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Card(
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },

            ):SizedBox(height: 1),
            ((alphabetical==true) && (searching==false)&& (categories==false))? StreamBuilder(
              stream: Firestore.instance.collection("Posts").orderBy('ProductName',descending: false).snapshots(),
              builder: (context,snapshot)  {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          print(snapshot.data.documents[index]['ProductName']);
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Card(
                                color: Colors.blue,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },

            ):SizedBox(height: 1),
            ((noBids==true) && (searching==false)&& (categories==false))?  StreamBuilder(
              stream: Firestore.instance.collection("Posts").where('maxBid', isEqualTo: 0).snapshots(),
              builder: (context,snapshot)  {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder (
                      shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Card(

                                color: Colors.blue,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },

            ):SizedBox(height: 1),
            ((fifty==true) && (searching==false)&& (categories==false))? StreamBuilder(
              stream: Firestore.instance.collection("Posts").where('maxBid', isLessThan: 50).snapshots(),
              builder: (context,snapshot)  {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder (
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Card(
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },

            ):SizedBox(height: 1),
            ((lhundred==true) && (searching==false)&& (categories==false))? StreamBuilder(
              stream: Firestore.instance.collection("Posts").where('maxBid', isLessThan: 100).snapshots(),
              builder: (context,snapshot)  {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder (
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: Card(
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },

            ):SizedBox(height: 1),
            ((gehundred==true) && (searching==false)&& (categories==false))? StreamBuilder(
              stream: Firestore.instance.collection("Posts").where('maxBid', isGreaterThanOrEqualTo: 100).snapshots(),
              builder: (context,snapshot)  {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                else {
                  return Expanded(
                    child: ListView.builder (
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index) {
                          int numPics = snapshot.data.documents[index]['numPics'];
                          List<Image> ims = [];
                          for (int i = 0; i < numPics; ++i) {
                            ims.add(Image.network(snapshot.data.documents[index]['imageURL'][i], height: 250, width: 250,));
                          }
                          return FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: Colors.blue,
                            child: Card(

                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data.documents[index]['ProductName'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          snapshot.data.documents[index]['minAskingPrice']<=snapshot.data.documents[index]['maxBid']?Text("\$"+snapshot.data.documents[index]['maxBid'].toString()):Text("\$"+snapshot.data.documents[index]['minAskingPrice'].toString())
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: ims,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          RaisedButton(
                                            child: Text("Buy Now"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Bid"),
                                            onPressed: () {
                                              Navigator.pushNamed(context, 'bid', arguments: snapshot.data.documents[index]['DocId']);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            onPressed: () async {
                              QuerySnapshot q_one = await Firestore.instance.collection("Posts").where('DocId', isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              QuerySnapshot q_two = await Firestore.instance.collection("Locations").where("docId", isEqualTo: snapshot.data.documents[index]['DocId']).getDocuments();
                              DocumentSnapshot docPosts = q_one.documents[0];
                              DocumentSnapshot docLocations = q_two.documents[0];
                              productInfoQuery obj = productInfoQuery(docPosts, docLocations);
                              Navigator.pushNamed(context, 'productInfo', arguments: obj);
                            }
                            ,
                          );
                        }
                    ),
                  );
                }
              },

            ):SizedBox(height:1)

          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text("Categories",  style: GoogleFonts.lobster(
                  color: Colors.white,
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold)),
              decoration: BoxDecoration(
                color: Color(0xFF00E5FF)
              ),
            ),
            ListTile(
              title: Text("Men\'s Clothing"),
              onTap: () {
                current2 = 'Men\'s Clothing';
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Women\'s Clothing"),
              onTap: () {
                current2 = "Women\'s Clothing";
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Accessories"),
              onTap: () {
                current2 = "Accessories";
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Room Decoration"),
              onTap: () {
                current2 = "Room Decoration";
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Kitchen"),
              onTap: () {
                current2 = "Kitchen";
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Bedroom"),
              onTap: () {
                current2 = "Bedroom";
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Textbooks"),
              onTap: () {
                current2 = "Textbooks";
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Other"),
              onTap: () {
                current2 = "Other";
                setState(() {
                  categories = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("View All"),
              onTap: () {
                setState(() {
                  categories = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Close Menu"),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF00E5FF),
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Feed")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile")
          ),
          BottomNavigationBarItem(
             icon: Icon(Icons.camera_alt),
            title: Text("Post")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_post_office),
            title: Text("Messages")
          )
        ],
        currentIndex: 0,
        selectedItemColor: Color(0xFF00E5FF),
        unselectedItemColor: Colors.blueGrey,
        onTap: (val) async {
          if (val == 0) {}
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
            FirebaseUser user = await AuthProvider().getUser();
            String uid = user.uid;
            QuerySnapshot qs = await Firestore.instance.collection("Users").where('uid', isEqualTo: uid).getDocuments();
            Navigator.pushNamed(context, 'messagingHome',arguments: qs.documents[0]);
          }
        },
      ) ,
    );
  }
}



class productInfoQuery {
  DocumentSnapshot locationsCollectionsDoc;
  DocumentSnapshot postsCollectionsDoc;

  productInfoQuery(DocumentSnapshot doc_one, DocumentSnapshot doc_two) {
    this.postsCollectionsDoc = doc_one;
    this.locationsCollectionsDoc = doc_two;
  }
  
}







