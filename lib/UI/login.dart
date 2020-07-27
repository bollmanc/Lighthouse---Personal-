import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/registerPage.dart';
import 'package:flutter_glogin/utils/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget{
  @override 
  _LoginPageState createState() => _LoginPageState();
}
  
class _LoginPageState extends State<LoginPage> {  
  String email;
  String password;

  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF00E5FF),
        ),
          ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 45,
              vertical: 30,
            ), 
        child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SizedBox(height:15.0),
              _buildTitle(),
              SizedBox(height: 15.0),
              _buildEmailTF(),
              SizedBox(height:15.0),
              _buildPasswordTF(),
              _buildLoginBtn(),
              _buildSignInText(),
              _buildGoogleLoginBtn(),
              _buildRegisterText(),
              _buildRegisterBtn(),
            ]
        )
          )),
        ],
      ),
        );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: 300.0,
      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'lighthouse',
                    style: GoogleFonts.lobster(
                      letterSpacing: 1.5,
                      color: Color(0xFFFFEA00),
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,),
      ),
                ],
      ),
      );
                
                
  }
  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 300.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed:() async {
         QuerySnapshot qs = await Firestore.instance.collection("Users").getDocuments();
         List<String> emails=[];
         for (int i = 0; i < qs.documents.length;++i) {
           emails.add(qs.documents[i]['email']);
         }
          Navigator.pushNamed(context, 'register',arguments: ListEmails(emails));
        },
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFFFEA00),
        child: Text(
          'Register',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: 300.0,
      child: Text(
        '---- OR ----',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'OpenSans',
        ),),
    );
  }

    Widget _buildRegisterText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: 300.0,
      child: Text(
        'Dont have an account?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'OpenSans',
        ),),
    );
  }

  Widget _buildGoogleLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      width: 300.0,
      child: RaisedButton(
                child: Text(
          'Login with Google',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
                onPressed: () async {
                  bool res = await AuthProvider().loginWithGoogle();
                  if(!res)
                    print("error logging in with google");
                },
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFFFEA00),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 300.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: ()async{
          bool res = await AuthProvider().signInWithEmail(email, password);
        },
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFFFEA00),
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: 300.0,
      child: TextField(
        onChanged: (val) {
          setState(() {
            password = val;
          });
        },
        obscureText: true,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top:16.0),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          hintText: 'Password',
        ),
      ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: 300.0,
      child: TextField(
        onChanged: (val) {
          setState(() {
            email = val;
          });
        },
        keyboardType:TextInputType.emailAddress,
           style: TextStyle(
             color: Colors.white,
             fontFamily: 'OpenSans',
             fontSize: 16.0,
             fontWeight: FontWeight.bold,
             
             ),
           decoration: InputDecoration(
             contentPadding: EdgeInsets.only(top:16.0),
             prefixIcon: Icon(
              Icons.email,
              color: Colors.white,
             ),
             hintText: 'Email',
          ),
         ),
      ),
      ],
    );
  }

  }

class ListEmails {
  List<String> emails;

  ListEmails(List<String> list) {
    this.emails = list;
  }

}