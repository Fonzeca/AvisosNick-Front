import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MindiaHttpClient extends http.BaseClient {
  static String _keyTokenPref = "tokenBack";

  String authorization = "Bearer ";
  final http.Client _inner;

  MindiaHttpClient(this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_keyTokenPref);
    request.headers['Content-Type'] = "application/json";
    request.headers['Authorization'] = authorization + token;
    return _inner.send(request);
  }

  ///1 Google, 2 Facebook, 3 UserAndPassword
  static void setToken(String token, int type) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTokenPref, token);
  }
}