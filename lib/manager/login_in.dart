import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/manager/mindia_http_client.dart';
import 'package:nick_tecnologia_notices/model/pojo_log_in.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: "944140954391-iuoilfj8dkfadhsog924buo7gnt32atl.apps.googleusercontent.com");
final ServidorRest _servidorRest = ServidorRest();

final String _keyEmail = "email";
final String _keyPassword = "password";



/// Funcion única para intentar loguearse con los 3 tipos de proveedores.
Future<bool> signIn(int type, BuildContext context, [String email, String password]) async {
  bool canLogIn = false;

  switch(type){
    case LOGIN_TYPE_GOOGLE:
      canLogIn = await signInWithGoogle();
      break;
    case LOGIN_TYPE_FACEBOOK:
      canLogIn = await signInWithFacebook();
      break;
    case LOGIN_TYPE_NORMAL:
      canLogIn = await signInBasic(email, password);
      break;
  }
  if(canLogIn){
    Navigator.pushReplacementNamed(context, '/dashBoard');
  }
  return canLogIn;
}

Future<bool> signInSilently() async{

  //Verificamos que tipo de inicio sesion tiene
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int type;
  try{
    type = prefs.getInt(keySaveLoginType);
  }catch(e){
  }

  //Si tiene un tipo de inicio de sesion activado
  if(type != null && type != 0){
    switch(type){
      case LOGIN_TYPE_GOOGLE:
        return await signInWithGoogle(true);
      case LOGIN_TYPE_FACEBOOK:
        //return await signInWithFacebook();
        break;
      case LOGIN_TYPE_NORMAL:
        return await signInBasicSiently();
    }
  }

  return false;
}

Future<bool> signOut(BuildContext context) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(keySaveLoginType);
  prefs.remove(_keyEmail);
  prefs.remove(_keyPassword);
  prefs.remove(keyPojoUser);
  await _googleSignIn.signOut();

  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
}



/**
 * Google sign In
 */

Future<bool> signInWithGoogle([bool siently = false]) async {

  GoogleSignInAccount googleUser = siently ? await _googleSignIn.signInSilently() : await _googleSignIn.signIn();

  GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  return await _servidorRest.loginWithGoogle(googleAuth.idToken);
}

Future<bool> signOutGoogle() async{
  await _googleSignIn.signOut();
}

/**
 * Facebook Sign In
 */

Future<bool> signInWithFacebook() async {
  LoginResult result = await FacebookAuth.instance.login();

  print(result.status);

  if(result.status != 200){
    return false;
  }
  return true;
}

/**
 * Basic Sign In
 */
Future<bool> signInBasic(String email, String password) async{
  if(await _servidorRest.login(email, password)){
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(_keyEmail, email);
    prefs.setString(_keyPassword, password);

    return true;
  }
  return false;
}

Future<bool> signInBasicSiently() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString(_keyEmail);
  String password = prefs.getString(_keyPassword);

  return await _servidorRest.login(email, password);
}

/**
 * Otros
 */

Future<PojoLogIn> obtenerLogInActual() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String pojoString =  prefs.getString(keyPojoUser);

  if(pojoString == null || pojoString.isEmpty){
    return null;
  }
  PojoLogIn pojoLogIn = PojoLogIn.fromJson(jsonDecode(pojoString));

  return pojoLogIn;
}


