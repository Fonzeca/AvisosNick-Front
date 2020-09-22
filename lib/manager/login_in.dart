import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_client.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
//final GoogleSignIn googleSignIn = GoogleSignIn();

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  print("Empieza la sing in");


//  OAuth2Client client = GoogleOAuth2Client(
//      redirectUri: 'https://www.mindia.com/oauth2redirect',
//      customUriScheme: 'https'
//  );
//  print("VOLVIO");
//
//  AccessTokenResponse token = await client.getTokenWithAuthCodeFlow(
//      clientId: '174045405795-8dtar248mrr1fbg45tga6icdlvpcdr1q.apps.googleusercontent.com',
//      scopes: ['email']
//  );
//
//  print("VOLVIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
//
//  if(token.isExpired()) {
//    token = await client.refreshToken(token.refreshToken);
//  }
//
//
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
    clientId: "174045405795-8dtar248mrr1fbg45tga6icdlvpcdr1q.apps.googleusercontent.com",
  );
  await _googleSignIn.signOut();

  GoogleSignInAccount googleAccount = await _googleSignIn.signIn();

  GoogleSignInAuthentication auth = await googleAccount.authentication;

  print("Debug MINDIA");
  print(auth.serverAuthCode);

  return null;
}

void signOutGoogle() async{


  print("User Sign Out");
}

Future<UserCredential> signIn(int type, BuildContext context){
  switch(type){
    case 1:
      return signInWithGoogle();
    case 2:
      print('Sing In With Facebook');
      break;
    case 3:
      print('Sing In With Firebase Basic');
      break;
  }
  Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardNotices(),));
  return null;
}