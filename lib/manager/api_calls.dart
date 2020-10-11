import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nick_tecnologia_notices/manager/mindia_http_client.dart';
import 'package:nick_tecnologia_notices/model/notice.dart';
import 'package:nick_tecnologia_notices/model/type.dart';
import 'package:nick_tecnologia_notices/model/user.dart';
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

  /**
   * Notice api calls
   */

  //Get a List of the user's notices.
  Future<List<NoticeModel>> checkNotices() async{
    String endpoint = "/notice/checkNotices";

    var response = await client.get(IpServer + ":" + Port + endpoint);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }

    var jsonData = json.decode(response.body);
    List<NoticeModel> notices= [];
    for(var n in jsonData){
      NoticeModel notice = new NoticeModel(n["_id"],n["title"],n["description"],n["author"],n["creationDate"],n["mails"],n["send"]);
      notices.add(notice);
    }
    return notices;

  }
  Future<void> createNotice(PojoCreateNotice pojoCreateNotice) async{
    String endpoint = "/notice/create";
    //TODO: test the json.
    var response = await client.post(IpServer + ":" + Port + endpoint,body: jsonEncode(pojoCreateNotice));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Noticia creada con éxito.");
  }

  //TODO: Deberia devolver un solo objeto, por eso existe el return dentro del for(), checkear
  Future<NoticeModel> getNoticeById(String id) async{
    String endpoint = "/notice/get";
    String params = "?id="+id;

    var response = await client.get(IpServer + ":" + Port + endpoint + params);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }

    var jsonData = json.decode(response.body);
    NoticeModel notice = null;
    for (var n in jsonData){
      notice= new NoticeModel(n["_id"], n["title"], n["description"], n["author"], n["creationDate"], n["mails"], n["send"]);
      return notice;
    }
  }

  Future<void> markNoticeAsRead(PojoId pojoId) async{
    String endpoint = "/notice/markAsRead";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoId));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print(pojoId.id);
  }

  Future<void> deactivateNotice(PojoId pojoId) async{
    String endpoint = "/notice/deactivate";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoId));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print(pojoId.id);
  }

  Future<void> modifyNotice(PojoModifyNotice pojoModifyNotice) async{
    String endpoint = "/notice/modify";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoModifyNotice));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print(pojoModifyNotice.title);
  }

  Future<List<String>> getNoticeReaders(PojoId pojoId) async{
    String endpoint = "/notice/readedBy";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoId));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print(pojoId.id);
  }


  /**
   * User api calls
   */
  Future<void> createUser(VUser user) async{
    String endpoint = "/user/create";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(user));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print(user.email);
  }

  Future<void> setTypeToUser(String mail,String type) async{
    String endpoint = "/user/setType";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(<String,String>{
      "string1":mail,
      "string2": type
    }));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
  }


  //TODO: asegurarse de que en la base de datos no este cargado el nombre y apellido.
  Future<List<PojoUser>> getUsers() async {
    String endpoint = "/user/allUsers";
    var response = await client.get(IpServer + ":" + Port + endpoint);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    var jsonData = json.decode(response.body);
    List<PojoUser> users= [];
    for(var n in jsonData){
      PojoUser user = new PojoUser(n["email"],n["uniqueMobileToken"],n["roles"],n["userType"]);
      users.add(user);
    }
    return users;
  }

  Future<List<PojoUser>> getUsersByType(String type) async {
    String endpoint = "/user/allUsersByType";
    String params = "?type=" + type;
    var response = await client.get(IpServer + ":" + Port + endpoint + params);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    var jsonData = json.decode(response.body);
    List<PojoUser> users= [];
    for(var n in jsonData){
      PojoUser user = new PojoUser(n["email"],n["uniqueMobileToken"],n["roles"],n["userType"]);
      users.add(user);
    }
    return users;
  }


  /**
   * UserType api calls
   */
  Future<void> createUserType(PojoUserType type) async{
    String endpoint = "/types/create";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(type));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Tipo de usuario creado con éxito!");
  }

  Future<List<UserType>> getAllUserTypes() async{
    String endpoint = "/types/allTypes";
    var response = await client.post(IpServer + ":" + Port + endpoint);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    var jsonData = json.decode(response.body);
    List<UserType> types= [];
    for(var n in jsonData){
      UserType type = new UserType(n["id"],n["code"],n["description"],n["active"]);
      types.add(type);
    }
    return types;
  }



}