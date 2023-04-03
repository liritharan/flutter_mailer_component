import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> signIn() async {
    if(await _googleSignIn.isSignedIn()){

      return _googleSignIn.currentUser;
    }
   else{
      return await _googleSignIn.signIn();
    }
  }
}
