import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/profileArgument.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_glogin/UI/profileArgument.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class PostPage extends StatefulWidget {
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Asset> images=null;
  String _error;
  File imageFile;
  bool pics=false;

  Future<void> loadAssetsFromGallery() async {
    setState(() {
      images = List<Asset>();
    });
    List<Asset> resultList;
    String error;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }


  Future<void> loadAssetsFromCamera() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Detected';
    });
  }

  Widget buildGridView() {
    if (images != null)
      return Expanded(
        child: GridView.count(
          crossAxisCount: 5,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return AssetThumb(
              asset: asset,
              width: 100,
              height: 100,
            );
          }),
        ),
      );
    else
      return Container();
  }



  @override
 Widget build(BuildContext context){
    return Scaffold(
      body: body(),
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
        currentIndex: 2,
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
  Widget body() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF00E5FF),
      ),
      child: Expanded(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
            horizontal:60.0,
            vertical: 120,
          ),
          children: <Widget>[
            Text(
              '   Select Image',
              style: GoogleFonts.lobster(
                  letterSpacing: 1.5,
                  color: Color(0xFFFFEA00),
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height:80),
            _buildGalleryBtn(),
            SizedBox(height:20),
            _buildOrText(),
            SizedBox(height: 20),
            _buildCameraBtn(),
            SizedBox(height: 20,),
          //  buildGridView(),
            images==null?Container():RaisedButton(
              child: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                assetsList obj = assetsList(images);
                Navigator.pushNamed(context, 'PostDetails', arguments: obj);
              },
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Color(0xFFFFEA00),
            )
          ],
        ),
      ),
    );
      bottomNavigationBar: Container(
        height: 80.0,
        decoration: BoxDecoration(
          color: Color(0xFF00E5FF),
          border: Border(
            top: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        padding: EdgeInsets.only(top: 1, bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.home, size: 30.0),
                onPressed: (){
              Navigator.pushNamed(context, 'feed');
              },
              ),
              IconButton(
                icon: Icon(Icons.camera_alt, size: 30.0),
                onPressed: (){
              Navigator.pushNamed(context, 'PostPage');
              },
              ),
            IconButton(
              icon: Icon(Icons.person, size: 30.0),
              onPressed: () async {
                  String url;
                FirebaseUser user = await AuthProvider().getUser();
                try {
                url = await FirebaseStorage.instance.ref().child(
                      user.uid).getDownloadURL();
                }
                catch (e) {
                  url = null;
                }
                profileArgument obj = profileArgument(user.uid,url);
                Navigator.pushNamed(context, '/ProfilePage', arguments: obj);
              },
              ),
          ]
        ),
      );
              
  }

  Widget _buildGalleryBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 175.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          loadAssetsFromGallery();
        },
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFFFEA00),
        child: Text(
          ("Gallery"),
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 22.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _buildOrText() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: 175.0,
        child: Text('---- OR ----',
         textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontFamily: 'OpenSans',
          ),)
    );
  }
  Widget _buildCameraBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 175.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          loadAssetsFromCamera();
        },
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFFFEA00),
        child: Text(
          ("Camera"),
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 22.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }




}

class assetsList {
  List<Asset> images;

  assetsList(List<Asset> list) {
    this.images = list;
  }
}
