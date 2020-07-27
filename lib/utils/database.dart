import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {
  final CollectionReference users= Firestore.instance.collection('Users');
  final CollectionReference posts = Firestore.instance.collection("Posts");
  final CollectionReference locations = Firestore.instance.collection("Locations");

   String uid;

  DatabaseService(String u) {
    uid = u;
  }

  Future setUserInfo(String name, String email, String password, int gradYear, String bio) async {
    return await users.document(uid).setData({
      'name': name,
      'uid': this.uid,
      'email': email,
      'password': password,
      'gradYear': gradYear,
      'bio': bio
    });

  }

  Future addPostInfo(String ProdName, String minPrice, String description, int picCount,List urls, String category) async {
   QuerySnapshot qs = await Firestore.instance.collection("Users").where('uid', isEqualTo: this.uid).getDocuments();
   String name = qs.documents[0]['name'];
    return await posts.add({
      'SellerName': name,
      'Seller_uid': this.uid,
      'ProductName': ProdName,
      'ProductDescription': description,
      'numPics': picCount,
      'imageURL': urls,
      'maxBid': 0,
      'map': Map<String,List<int>>(),
      'time': Timestamp.fromDate(DateTime.now()),
      'minAskingPrice': int.parse(minPrice),
      'category': category
    });

  }

  Future addMessage(String to, String from, String text) async {
    List<String> people = [to, from];
    String ppl = alphabeticalFunction(to, from);
    return await Firestore.instance.collection("Messages").add({
      'To': to,
      'From': from,
      'Text': text,
      'People': people,
      'convoID': ppl,
      'Time': Timestamp.fromDate(DateTime.now()),
    });
  }
  
  Future addLocationInfo(String docId, Set<Marker> markers, bool negotiate) async {
    Marker m;
    double lat;
    double long;
    List<String> coords= [];
    for (int i = 0; i < markers.length; ++i) {
      m = markers.elementAt(i);
      lat = m.position.latitude;
      long = m.position.longitude;
      coords.add(lat.toString()+", "+long.toString());
    }
    return await locations.add({
      'docId': docId,
      'locations': coords,
      'negotiate': negotiate
    });
  }

  Future setDocId(String id) async {
    return await posts.document(id).updateData({'DocId':id});
  }

  Future addBid(String id, int bid, String buy_uid) async {

   DocumentSnapshot doc =  await posts.document(id).get();
    Map map = doc.data['map'];
    print(map);
   List<dynamic> list = map[buy_uid];
   if (list!= null) {
     list.add(bid);
     map[buy_uid] = list;
     if (bid > doc.data['maxBid']) {
       await posts.document(id).updateData({'maxBid':bid});
     }
     return await posts.document(id).updateData({'map':map});
   }
   else {
     list = [bid];
     map[buy_uid]=list;
     if (bid > doc.data['maxBid']) {
       await posts.document(id).updateData({'maxBid':bid});
     }
     return await posts.document(id).updateData({'map':map});
   }

  }


   getUserInfoByUID() {
      return Firestore.instance.collection("Users").document(this.uid).get();
  }

  alphabeticalFunction(String one, String two) {
    if (one.compareTo(two) == -1) {
      return one+","+two;
    }
    else {
      return two+","+one;
    }

  }



}