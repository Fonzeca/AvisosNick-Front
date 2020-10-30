import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/manager/mindia_http_client.dart';
import 'package:nick_tecnologia_notices/model/pojo_log_in.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

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
  int type;
  try{
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
  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
}



/**
 * Google sign In
 */

Future<bool> signInWithGoogle([bool siently = false]) async {


}

Future<bool> signOutGoogle() async{
}

/**
 * Facebook Sign In
 */

Future<bool> signInWithFacebook() async {

  return true;
}

/**
 * Basic Sign In
 */
Future<bool> signInBasic(String email, String password) async{
  if(await _servidorRest.login(email, password)){

    return true;
  }
  return false;
}

Future<bool> signInBasicSiently() async{
}

/**
 * Otros
 */

Future<PojoLogIn> obtenerLogInActual() async {
    return null;
}


