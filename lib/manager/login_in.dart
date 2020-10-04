import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(clientId: "944140954391-iuoilfj8dkfadhsog924buo7gnt32atl.apps.googleusercontent.com");
final ServidorRest _servidorRest = ServidorRest();

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
    case 1:
      canLogIn = await signInWithGoogle();
      break;
    case 2:
      print('Sing In With Facebook');
      break;
    case 3:
      print('Sing In With Firebase Basic');
      break;
  }
  if(canLogIn){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardNotices(),));
  }
  return canLogIn;
}