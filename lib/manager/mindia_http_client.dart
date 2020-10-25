import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nick_tecnologia_notices/model/pojo_log_in.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_in.dart';

class MindiaHttpClient extends http.BaseClient {

  String authorization = "Bearer ";
  final http.Client _inner;

  MindiaHttpClient(this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    PojoLogIn pojoLogIn = await obtenerLogInActual();

    String token = pojoLogIn.token;

    request.headers['Content-Type'] = "application/json; charset=utf-8";
    request.headers['Authorization'] = authorization + token;
    return _inner.send(request);
  }

  ///1 Google, 2 Facebook, 3 UserAndPassword
  static void setPojoLogin(PojoLogIn login, int type) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyPojoUser, jsonEncode(login));

    //Guardamos el tipo de inicio de sesion
    await prefs.setInt(keySaveLoginType, type);
  }
}