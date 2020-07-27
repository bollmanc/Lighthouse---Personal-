import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_glogin/User/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  updateUser(String e, String p) async {
    FirebaseUser user = await _auth.currentUser();
    await user.updateEmail(e);
    await user.updatePassword(p);
    return;
  }

   User createUser(FirebaseUser u) {
     if (u==null) {
       return null;
     }
     return User(u.uid);
   }
    Future<FirebaseUser> getUser() async {
     return await _auth.currentUser();
    }

  Future handleRegister(email, password) async {

    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;

  }


  Future<bool> signInWithEmail(String email, String password) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email.trim(),password: password);
      FirebaseUser user = result.user;
      if(user != null)
      return true;
      else
      return false;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if(account == null )
        return false;

      String name = account.displayName;
      String email = account.email;

      //Check for lehigh domain
      if(email == null) {
        return false;
      }
      String domain = email.split("@")[1];
      if("lehigh.edu" != domain.toLowerCase()) {        
        return false;
      }

      AuthResult res = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      if(res.user == null)
        return false;

      
      
      await DatabaseService(res.user.uid).setUserInfo(name, email, "NA",null, "");

      return true;
    } catch (e) {
      print(e.message);
      print("Error logging with google");
      return false;
    }
  }
}