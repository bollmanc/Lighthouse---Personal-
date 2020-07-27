import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class map extends StatefulWidget {
  @override
  _mapState createState() => _mapState();
}


class _mapState extends State<map> {
  final Set<Marker> _markers = {Marker(
      alpha: 1.0,
      markerId: MarkerId(0.toString()),
      infoWindow: InfoWindow(title: "Lehigh University"),
      position: LatLng(40.6049,-75.3775),
      visible: true),
    Marker(
        alpha: 1.0,
        markerId: MarkerId(1.toString()),
        infoWindow: InfoWindow(title: "Taylor Gym"),
        position: LatLng(40.607202,-75.374180),
        visible: true),
    Marker(
        alpha: 1.0,
        markerId: MarkerId(2.toString()),
        infoWindow: InfoWindow(title: "University Center"),
        position: LatLng(40.606076,-75.378541),
        visible: true),
    Marker(
        alpha: 1.0,
        markerId: MarkerId(3.toString()),
        infoWindow: InfoWindow(title: "Linderman Library"),
        position: LatLng(40.606495,-75.376902),
        visible: true),
    Marker(
        alpha: 1.0,
        markerId: MarkerId(4.toString()),
        infoWindow: InfoWindow(title: "Alpha Phi"),
        position: LatLng(40.601910,-75.376242),
        visible: true)

  };
  GoogleMapController gmc;
  int markId=5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map")),
      body: Stack(
        children: <Widget>[
          GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  gmc = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(40.604832,-75.377133),
                zoom: 25.0
              ),
            markers: _markers,
            onTap: (position) {
                Marker m = Marker(markerId: MarkerId(markId.toString()),position: position);
                ++markId;
                setState(() {
                  _markers.add(m);
                });
            },
            ),

          Align(
            alignment: Alignment.topLeft,
            child: FloatingActionButton(
              child: Icon(Icons.add_location),
              onPressed: () async{
                var curLoc = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                print(curLoc.latitude);
                print(curLoc.longitude);
                setState(() {
                  _markers.add(
                    Marker(markerId: MarkerId(5.toString()),
                            position: LatLng(curLoc.latitude, curLoc.longitude),
                            infoWindow: InfoWindow(title: "Your current location")
                    ));
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
