import 'package:flutter/material.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';



class Edit extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<Edit> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _bioController;
  String dropdownValue;
  List<int> list0;
  String uid;
  File imageFile;

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _bioController = TextEditingController(text: "");
     dropdownValue = '2021';
     list0 = new List<int>.generate(20, (int index)=>2021+index);

  }



  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  List<String> convertList(List<int> l) {
    List<String> list2=[];
    for (int i = 0; i < l.length; ++i) {
      list2.add(l[i].toString());
    }
    return list2;
  }

  _openGallery(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();

  }

  Widget _decideImageView(){
    if(imageFile == null){
      return Text("No Image Selected");
    } else{
      return Text("Image saved, waiting for submission!");

    }
  }


  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose Picture Method"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Existing From Gallery"),
                onTap: (){
                  _openGallery(context);
                },
              ),

              Padding(padding: EdgeInsets.all(8.0)),

              GestureDetector(
                child: Text("Take Picture"),
                onTap: (){
                  _openCamera(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00E5FF),
        title: Text("Edit Profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              AuthProvider().logOut();
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _decideImageView(),
            TextFormField(
        decoration: const InputDecoration(
          hintText: 'Edit name',
        ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
            controller: _nameController,
          ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Edit email'
              ),
              controller: _emailController,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Edit password'
              ),
              obscureText: true,
              controller: _passwordController,
            ),
            TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Edit bio',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a short bio';
                  }
                  return null;
                },
              controller: _bioController,
                ),
            SizedBox(),
        Text("Edit Year of Graduation"),
        SizedBox(),
        DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: convertList(list0)
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
                child: Text(value),
            );
          }).toList(),
        ),
            RaisedButton(
              child: Text("Select a Profile picture"),
              onPressed: ()  {
                _showChoiceDialog(context);
              },
            ),
            RaisedButton(
                onPressed: () async {
                if(_formKey.currentState.validate()) {
                  await AuthProvider().updateUser(_emailController.text, _passwordController.text);
                  await DatabaseService(ModalRoute.of(context).settings.arguments).setUserInfo(_nameController.text, _emailController.text, _passwordController.text,null, _bioController.text);
                  StorageReference ref = FirebaseStorage.instance.ref().child(ModalRoute.of(context).settings.arguments);
                  StorageUploadTask task = ref.putFile(imageFile);
                  await task.onComplete;
                  Navigator.pop(context);
                }
                else {

                }
                },
                child: Text("Submit")
            )]
        )
      ),
    );
  }
}








