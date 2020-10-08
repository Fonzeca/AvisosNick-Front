import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nick_tecnologia_notices/manager/mindia_http_client.dart';
import 'package:nick_tecnologia_notices/model/notice.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:universal_io/io.dart';

class ServidorRest {
  final client = MindiaHttpClient(http.Client());
  final String IpServer = "http://vps-1791261-x.dattaweb.com";
  final String Port = "45589";


  Future<void> login(String email, String password) async {
    String endpoint = "/login";
    String requestParam = "?email=" + email + "&password=" + password;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    MindiaHttpClient.setToken(response.body, LOGIN_TYPE_NORMAL);
  }

  Future<String> loginWithGoogle(String idTokenOAuth) async {
    String endpoint = "/loginWithGoogle";
    String requestParam = "?idToken=" + idTokenOAuth;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    MindiaHttpClient.setToken(response.body, LOGIN_TYPE_GOOGLE);
    return response.body;
  }

  Future<bool> validateToken() async{
    String endpoint = "/validateToken";

    var response = await client.post(IpServer + ":" + Port + endpoint);

    if(response.body.isNotEmpty && response.body == "true"){
      return true;
    }else if(response.statusCode == 401){
      return false;
    }else{
      throw new Exception("Error al conectar al servidor.");
    }
  }
  
  Future<void> setToken(String token) async{
    String endpoint = "/user/setToken";
    String params = "?token=" + token;

    var resposne = await client.post(IpServer + ":" + Port + endpoint + params);
    if(resposne.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
  }

  //TODO: retrieve all notices from back (Chceck token)
  Future <List> checkNotices() async{
    String endpoint = "/notice/checkNotices";

    var response = await client.get(IpServer + ":" + Port + endpoint);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }

    var jsonData = json.decode(response.body);
    List<NoticeModel> notices= [];
    for(var n in jsonData){
      NoticeModel notice = new NoticeModel(n["title"],n["description"],n["author"],n["creationDate"]);
      notices.add(notice);
    }
    return notices;

  }

}