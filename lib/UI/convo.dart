import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';

class convo extends StatefulWidget {
  @override
  _convoState createState() => _convoState();
}

class _convoState extends State<convo> {
  String userEmail;
  String otherEmail;
  String ppl;
  bool back = true;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "");
  }

  alphabeticalFunction(String one, String two) {
    if (one.compareTo(two) == -1) {
      return one+","+two;
    }
    else {
      return two+","+one;
    }

  }

  @override
  Widget build(BuildContext context) {
    String str = ModalRoute.of(context).settings.arguments;
    List<String> emails = str.split(',');
    userEmail = emails[0];
    otherEmail = emails[1];
    ppl = alphabeticalFunction(userEmail, otherEmail);
    return Scaffold(
      appBar: AppBar(
        title: Text(otherEmail),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                 stream: Firestore.instance.collection("Messages").where('convoID', isEqualTo: ppl).orderBy('Time', descending: false).snapshots(),
                 builder: (context, snapshots) {
                   if (!snapshots.hasData) {
                     return Text("loading!");
                   }
                   else {
                     return Container(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: ListView.builder(
                         shrinkWrap: true,
                         itemCount: snapshots.data.documents.length,
                         itemBuilder: (context, index) {
                           DateTime time = snapshots.data.documents[index]['Time'].toDate();

                           return Row(
                             children: <Widget>[
                               Container(
                                 decoration: BoxDecoration(
                                   color: snapshots.data.documents[index]['From']==userEmail?Colors.lightBlue:Colors.lightGreen,
                                   borderRadius: BorderRadius.only(
                                     topLeft: Radius.circular(20),
                                     topRight: Radius.circular(20),
                                     bottomLeft: Radius.circular(20),
                                     bottomRight: Radius.circular(20)
                                   )
                                 ),
                                 margin:  snapshots.data.documents[index]['From']==userEmail?EdgeInsets.only(left: 60, top: 10, right:0,bottom: 10):
                                 EdgeInsets.only(top: 10, right: 60, bottom: 10),
                                 width: MediaQuery.of(context).size.width*0.8,
                                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                 child: Column(
                                   children: <Widget>[
                                     Text(snapshots.data.documents[index]['Text'],style: TextStyle(
                                       color: Colors.white,
                                       fontWeight: FontWeight.bold,
                                     ),),
                                     SizedBox(height: 5,),
                                     Text(time.toString(), style: TextStyle(
                                       color: Colors.black.withOpacity(0.6),

                                     ),)
                                   ],
                                 ),
                               ),
                             ],

                           );
                         },
                       ),
                     );
                   }
                 },
               ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {

                FirebaseUser user = await AuthProvider().getUser();
                DatabaseService(user.uid).addMessage(otherEmail, userEmail, _controller.text);
                _controller.clear();
              },
            )

          ),
             TextFormField(
               controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter message"),
               minLines: 2,
               maxLines: 6,
              ),
        ],
        
      )
    );
  }
}
