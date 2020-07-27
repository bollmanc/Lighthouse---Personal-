
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/post.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

@override
class PostDetails2 extends StatefulWidget {

  @override
  _details createState() => _details();
}

class _details extends State<PostDetails2> {

  GoogleMapController _controller;
  String minAskPrice;
  String prodName;
  String descr;


  int markId = 0;
  int picCount;
  String imageName;
  List<Asset> assets;
  List urls = [];

  final Set<Marker> _pins = {};
  bool dropPin;
  bool negotiate;
  bool postFailed = false;
  String def = 'Select a Category';
  String current = 'Select a Category';
  @override
  void initState() {
    dropPin = false;
    negotiate = false;
  }



  @override
  Widget build(BuildContext context) {
    assetsList obj = ModalRoute.of(context).settings.arguments;
    assets = obj.images;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF00E5FF),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal:30.0,
            vertical: 120,
          ),
          children: <Widget>[
            Text(
              'Post',
              style: GoogleFonts.lobster(
                  letterSpacing: 1.5,
                  color: Color(0xFFFFEA00),
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.0),
            _buildNameTF(),
            SizedBox(height:15.0),
            _buildDescriptionTF(),
            SizedBox(height:15.0),
            _buildCategoryDM(),
            SizedBox(height: 15,),
            _buildPriceTF(),
            SizedBox(height:15.0),
            _buildSwitchListTile(),
            SizedBox(height:15.0),
            SizedBox(height: 300,
              width: 300,
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    _controller = controller;
                  });
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(40.604832,-75.377133),
                    zoom: 25.0
                ),
                markers: _pins,
                onTap: (position) {
                  Marker m = Marker(markerId: MarkerId(markId.toString()),position: position, infoWindow: InfoWindow(title: "Pin " + markId.toString()));
                  ++markId;
                  setState(() {
                    _pins.add(m);
                  });
                },
              ),
            ),
            Center(
              child: FloatingActionButton(
                child: Icon(Icons.clear),
                backgroundColor: Colors.red,
                onPressed: () {
                  setState(() {
                    if (_pins.length != 0) {
                      _pins.remove(_pins.elementAt(
                          _pins.length - 1)); //remove most recent pin!
                    }
                  });
                },
              ),
            ),
            SizedBox(height:15.0),
            
            RaisedButton(
              child: Text(
          ("Upload Post"),
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 22.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
              onPressed: () async {
                var price;
                try {
                   price = int.parse(minAskPrice);
                } catch (e) {
                  price = -1;
                }
                if ((_pins.length!=0)&&(prodName!=null)&&(prodName.length>0)&&(price>0)&&(descr!=null)&&(descr.length>0)&&(current!='Select a Category')) {
                  picCount = assets.length;
                  FirebaseUser user = await AuthProvider().getUser();
                  for (int i = 0; i < picCount; ++i) {
                    imageName = user.uid+descr+i.toString();
                    StorageReference ref = FirebaseStorage.instance.ref().child(imageName);
                    ByteData byteData = await assets[i].requestOriginal();
                    List<int> imageData = byteData.buffer.asUint8List();
                    StorageUploadTask uploadTask = ref.putData(imageData);
                    await uploadTask.onComplete;
                    String url = await FirebaseStorage.instance.ref().child(imageName).getDownloadURL();
                    urls.add(url);
                  }

                  DocumentReference doc_ref = await DatabaseService(user.uid).addPostInfo(prodName, minAskPrice, descr,picCount,urls,current);
                  String id = doc_ref.documentID;
                  await DatabaseService(user.uid).setDocId(id);
                  await DatabaseService(user.uid).addLocationInfo(id, _pins, negotiate);
                  Navigator.pushNamed(context, "feed");
                }
                else {
                  setState(() {
                    postFailed=true;
                  });
                }
              },
               padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFFFEA00),
            ),
            postFailed==true?Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Posting Failed!"),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      postFailed = false;
                    });
                  },
                )
              ],
            ):SizedBox(height: 1)
          ],

        ),
      ),
    );
  }

  Widget _buildCategoryDM() {
    List<String> choices = ['Select a Category','Men\'s Clothing', 'Women\'s Clothing', 'Accessories', 'Room Decoration', 'Kitchen', 'Bedroom', 'Textbooks', 'Other'];

    return DropdownButton<String>(
      value: current,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (val) {
        setState(() {
          current = val;
        });
      },
      items: choices
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionTF() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top:16.0),
        prefixIcon: Icon(
          Icons.event_note,
          color: Colors.white,
        ),
        hintText: 'Description',
        helperText: 'Must be non-empty',
        helperStyle: TextStyle(color: Colors.black)

      ),
     onChanged: (val) {
        setState(() {
          descr = val;
        });
     },

    );
  }

  Widget _buildNameTF() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top:16.0),
        prefixIcon: Icon(
          Icons.input,
          color: Colors.white,
        ),
        hintText: 'Product Name',
        helperText: "Cannot be empty",
        helperStyle: TextStyle(color: Colors.black)
      ),
      onChanged: (val) {
        setState(() {
          prodName = val;
        });
      },

    );
  }

  Widget _buildPriceTF() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top:16.0),
        prefixIcon: Icon(
          Icons.attach_money,
          color: Colors.white,
        ),
        hintText: 'Minimum Asking Price',
        helperText: 'Exclude dollar sign and must be strictly positive',
        helperStyle: TextStyle(color:Colors.black,)
      ),
      onChanged: (val) {
        setState(() {
          minAskPrice = val;
        });
      },
    );
  }

  Widget _buildSwitchListTile() {
    return SwitchListTile(
      title: Text("Willing to negotiate exchange sites"),
      value: negotiate,
      onChanged: (val) {
        setState(() {
          negotiate = val;
        });
      },
    );
  }


}


