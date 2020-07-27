import 'package:flutter/material.dart';
import 'package:flutter_glogin/UI/feed.dart';
// import 'package:flutter_glogin/UI/splash.dart';
import 'package:flutter_glogin/UI/SplashScreen.dart';
import 'package:flutter_glogin/UI/login.dart';
//import 'package:flutter_fire_auth/utils/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_glogin/UI/messaging.dart';
import 'package:flutter_glogin/UI/ownProductInfo.dart';
import 'package:flutter_glogin/UI/profile.dart';
import 'package:flutter_glogin/UI/registerPage.dart';
import 'UI/bid.dart';
import 'UI/buyNow.dart';
import 'UI/convo.dart';
import 'UI/createNewMessage.dart';
import 'UI/map.dart';
import 'UI/post.dart';
import 'UI/editProfile.dart';
import 'UI/postDetails2.dart';
import 'UI/productInfo.dart';
import 'UI/seeOtherProfile.dart';
import 'UI/sellingPage.dart';
import 'UI/viewOwnPosts.dart';

void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/ProfilePage': (BuildContext context) => ProfilePage(),
        'seeOtherProfile': (BuildContext context) => seeOtherProfile(),
        'register': (BuildContext context) => RegisterForm(),
        'PostPage': (BuildContext context) => PostPage(),
        'PostDetails': (BuildContext context) => PostDetails2(),
        'sell': (BuildContext context) => sell(),
        'bid': (BuildContext context) => Bid(),
        'buyNow': (BuildContext context) => Buy(),
        'edit': (BuildContext context) => Edit(),
        'feed': (BuildContext context) => Home(),
        'productInfo': (BuildContext context) => productInfo(),
        'myPosts': (BuildContext context) => myPosts(),
        'ownProductInfo': (BuildContext context) => ownProductInfo(),
        'map': (BuildContext context) => map(),
        'messagingHome': (BuildContext context) => messaging(),
        'createNewMessage': (BuildContext context) => createNewMessage(),
        'convo': (BuildContext context) => convo(),
      },
      home: SplashScreen(),//MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context,AsyncSnapshot<FirebaseUser> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return SplashScreen();
        if(!snapshot.hasData || snapshot.data == null)
          return LoginPage();
        return Home();
      },
      );

  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _seletedItem = 0;
  var _pages = [Home(), PostPage(), ProfilePage()];
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lighthouse'),
      ),
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _seletedItem = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo), title: Text('Photos')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('Profile'))
        ],
        currentIndex: _seletedItem,
        onTap: (index) {
          setState(() {
            _seletedItem = index;
            _pageController.animateToPage(_seletedItem,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
      ),
    );
  }
}

