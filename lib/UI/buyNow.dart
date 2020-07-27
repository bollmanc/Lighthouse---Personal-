import 'package:flutter/material.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Buy extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Now"),
      ),
      body: Text("User wants to buy now!"),
    );
  }
}
