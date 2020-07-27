import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/login.dart';
import 'package:flutter_glogin/utils/database.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class RegisterForm extends StatefulWidget {
@override
_State createState() => _State();
}

class _State extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String name='';
  String email='';
  String password='';
  String uid='';
  final auth = AuthProvider();
  List<String> emails;
  bool showNotif = false;
  var years = List<int>.generate(4, (index) => 2021+index);
  int dropdownVal = 2021;

  Widget _buildNameTF() {
    return TextFormField(
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 22.0),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                hintText: 'Enter First and Last Name',
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            );
  }


  Widget _buildEmailTF() {
    return TextFormField(
    keyboardType:TextInputType.emailAddress,
    onChanged: (val1) {
    setState(() {
    email = val1;
    });},
    style: TextStyle(
    color: Colors.white,
    fontFamily: 'OpenSans',
    fontSize: 16.0,
    fontWeight: FontWeight.bold,),
    decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.only(top:22.0),
    prefixIcon: Icon(
    Icons.email,
    color: Colors.white,
    ),
    hintText: 'Enter Lehigh Email',
    helperText: 'Must end in @lehigh.edu'
    ),);}

  Widget _buildPasswordTF() {
    return TextFormField(
    obscureText: true,
    onChanged: (val2) {
    setState(() {
    password = val2;
    });},
    style: TextStyle(
    color: Colors.white,
    fontFamily: 'OpenSans',
    fontSize: 16.0,
    fontWeight: FontWeight.bold,),
    decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.only(top:22.0),
    prefixIcon: Icon(
    Icons.lock,
    color: Colors.white,
    ),
    hintText: 'Enter Lehigh Password',
    helperText: "Must be at least 8 characters long "
    ),);}


  Widget _buildRegisterBtn(List<String> emails) {
  List<String> e = emails;
    return RaisedButton(
        elevation: 5.0,
    onPressed: () async {
    if ((name!=null)&&(name.length>0)&&(email!=null)&&(email.indexOf('@lehigh.edu')!=-1)&&(password!=null)&&(password.length>7)&&(emails.indexOf(email)==-1))  {
    dynamic user = await auth.handleRegister(email, password);
    if (user!= null) {
    uid = user.uid;
    //store info in database
    await DatabaseService(uid).setUserInfo(name, email, password, dropdownVal, '');
    //and then navigate back to log in page
    Navigator.pop(context);
    }
    }
    else {
      setState(() {
        showNotif=true;
      });
    }
    },
    padding: EdgeInsets.symmetric(vertical: 15.0),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
    ),
    color: Color(0xFFFFEA00),
    child: Text(
    'Register',
    style: TextStyle(
    color: Colors.black,
    letterSpacing: 1.5,
    fontSize: 22.0,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
    ),
    ),
        );}


      Widget _buildClassYear() {

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Class of "),
            DropdownButton<int>(
              value: dropdownVal,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (int val) {
                setState(() {
                  dropdownVal = val;
                });
              },
              items: years.map<DropdownMenuItem<int>>((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
            ),
          ],
        );
      }





    @override
  Widget build(BuildContext context){
      ListEmails obj = ModalRoute.of(context).settings.arguments;
      emails = obj.emails;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF00E5FF),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal:30.0,
            vertical: 120,
          ),
          children: <Widget> [Text(
            'Register',
            style: GoogleFonts.lobster(
                letterSpacing: 1.5,
                color: Color(0xFFFFEA00),
                fontSize: 50.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.0),
          _buildNameTF(),
          SizedBox(height:15.0),
          _buildEmailTF(),
          SizedBox(height:15.0),
          _buildPasswordTF(),
            SizedBox(height:15.0),
            _buildClassYear(),
            SizedBox(height:15.0),
          _buildRegisterBtn(emails),
          showNotif==true?Row(
            children: <Widget>[
              Text("Register Failed!",style: TextStyle(color: Colors.red),),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    showNotif= false;
                  });
                },
              )
            ],
          ):SizedBox(height: 1,)]
        ),
      ),
    );
  }




























}
