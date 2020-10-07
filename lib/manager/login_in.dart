import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(clientId: "944140954391-iuoilfj8dkfadhsog924buo7gnt32atl.apps.googleusercontent.com");
final ServidorRest _servidorRest = ServidorRest();
final FirebaseMessaging messaging = FirebaseMessaging();

Future<bool> signInWithGoogle() async {
  GoogleSignInAccount googleUser = await googleSignIn.signInSilently();

  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  String token = await _servidorRest.loginWithGoogle(googleAuth.idToken);

  return true;
}

void signOutGoogle() async{
  await googleSignIn.signOut();
}


/// Funcion unica para intentar loguearse con los 3 tipos de proveedores.
Future<bool> signIn(int type, BuildContext context) async {
  bool canLogIn = false;

  switch(type){
    case LOGIN_TYPE_GOOGLE:
      canLogIn = await signInWithGoogle();
      break;
    case LOGIN_TYPE_FACEBOOK:
      print('Sing In With Facebook');
      break;
    case LOGIN_TYPE_NORMAL:
      print('Sing In With Firebase Basic');
      canLogIn = true;
      break;
  }
  if(canLogIn){
    messaging.getToken().then((value) => _servidorRest.setToken(value));
    Navigator.pushReplacementNamed(context, '/dashBoard');
  }
  return canLogIn;
}