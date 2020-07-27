import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'feed.dart';
import 'package:google_fonts/google_fonts.dart';



class productInfo extends StatefulWidget {
  @override
  _productInfoState createState() => _productInfoState();
}

class _productInfoState extends State<productInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    productInfoQuery obj = ModalRoute.of(context).settings.arguments;
    DocumentSnapshot docPosts = obj.postsCollectionsDoc;
    DocumentSnapshot docLocations = obj.locationsCollectionsDoc;
    GoogleMapController _controller;
    String docId = docPosts['DocId'];
    List<Image> ims = [];
    int numPics = docPosts['numPics'];
    Set<Marker> _pins={};
    bool negotiate;
    String locStr;
    double lat;
    double long;
    List<String> splitString;
    for (int i = 0; i < numPics; ++i) {
      ims.add(Image.network(docPosts['imageURL'][i], height: 150, width: 200,));
    }
    for (int i = 0; i < docLocations['locations'].length; ++i) {
      locStr = docLocations['locations'][i];
      splitString = locStr.split(',');
      lat = double.parse(splitString[0]);
      long = double.parse(splitString[1]);
      _pins.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(lat,long),
          infoWindow: InfoWindow(
            snippet: "Seller willing to exchange here"
          ),
        )
      );

      return Scaffold(
        backgroundColor: Color(0xFF00E5FF),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF00E5FF),
          title: Text(
            "lighthouse",
            style: GoogleFonts.lobster(
                letterSpacing: 1.5,
                color: Color(0xFFFFEA00),
                fontSize: 36.0,
                fontWeight: FontWeight.normal
            ),
          ),
        ),

        body: ListView(
          children: <Widget>[
          SizedBox(
            height: 650.0,
            child: Stack(
              children: <Widget>[
                Container(
                margin: EdgeInsets.only(top: 250),
                padding: EdgeInsets.only(top: 50, left: 25),
                //height: 400,
                decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
            ),
            
            child: Column(
              children: <Widget>[
                Row(
                 children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                  Text(docPosts['category'],
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,),
                ),],),
                RichText(
                     text: TextSpan(
                       children: [
                         TextSpan(text: '              Max Bid:'),
                         TextSpan(text:"Max Bid: \$${docPosts['minAskingPrice'].toString()}",
                         style: Theme.of(context)
                         .textTheme
                         .headline4
                         .copyWith(
                           color: Colors.black,
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                         )
                         )
                       ],
            ),
                ),
                ], 
                ),
               Padding(padding: const EdgeInsets.symmetric(
                 vertical: 25, horizontal: 30),
               child:
                Row(
                 children: <Widget>[
                  RaisedButton(
                       onPressed: () {
                         Navigator.pushNamed(context, 'bid', arguments: docId);
                },
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(0xFFFFEA00),
        child: Text(
          'Bid',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 20.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
              ),
              SizedBox(width: 10),
              Padding(padding: const EdgeInsets.symmetric(
                horizontal: 20),
              ),
              Expanded(   
                child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(0xFFFFEA00),
        child: Text(
          'Buy Now',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 20.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
              ) 
                        
        )
                 ],
                  ),
               ),
                ], 
                
                ),
               ),
                
                Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(docPosts['SellerName'],
                    style: TextStyle(color: Colors.white),),
                  SizedBox(height: 10),
                  Text(docPosts['ProductName'],
                    style: Theme.of(context).textTheme.headline4.copyWith(
                   color: Colors.white,          
                        fontWeight: FontWeight.bold
                    ) 
                             ),   
                 SizedBox(height:10),       
                 Row(
                 children: <Widget>[
                   RichText(
                     text: TextSpan(
                       children: [
                         TextSpan(text: 'Price\n'),
                         TextSpan(text:"\$${docPosts['minAskingPrice'].toString()}",
                         style: Theme.of(context)
                         .textTheme
                         .headline4
                         .copyWith(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         )
                         )
                       ]
                     ),),
                     SizedBox(width: 60),
                     numPics>1?
                       Expanded(
                child: SizedBox(   
                  height: 100,  
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ims,
                  ),
                ),      
              ):Image.network(docPosts['imageURL'][0], height: 200, width: 200,
              fit: BoxFit.fill,
  
              ),
                 ],
                 ),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 150,)
                ],
              ),
                Expanded(  
                  child: SizedBox(
                    
                    height: 200,
                    width: 200,
                    child: GoogleMap(
                        onMapCreated: (controller) {
                          _controller = controller;
                        },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(40.604832,-75.377133),
                          zoom: 25.0
                      ),
                      markers: _pins,
                    ),
                  ),
                ),
                ],
                ),
                ),
          ],
          ),
          ),
        ],
        )
      );
    }
  }
}



