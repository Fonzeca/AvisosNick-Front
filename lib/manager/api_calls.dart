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

  Future<bool> login(String email, String password) async {
    String endpoint = "/login";
    String requestParam = "?email=" + email + "&password=" + password;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    print("Login basic");
    print(response.statusCode);
    print(response.body);
    if(response.statusCode != 200){
      return false;
    }

    MindiaHttpClient.setToken(response.body, LOGIN_TYPE_NORMAL);
    return true;
  }

  Future<bool> loginWithGoogle(String idTokenOAuth) async {
    String endpoint = "/loginWithGoogle";
    String requestParam = "?idToken=" + idTokenOAuth;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    print("Login Google");
    print(response.statusCode);
    print(response.body);
    if(response.statusCode != 200){
      return false;
    }
    MindiaHttpClient.setToken(response.body, LOGIN_TYPE_GOOGLE);
    return true;
  }

  Future<bool> validateToken() async{
    String endpoint = "/validateToken";

    var response = await client.get(IpServer + ":" + Port + endpoint);
    print("validateToken");
    print(response.statusCode);
    print(response.body);

    if(response.body.isNotEmpty && response.body == "true"){
      return true;
    }else{
      return false;
    }
  }



  /**
   * Notice api calls
   */


  Future<void> createNotice(PojoCreateNotice pojoCreateNotice) async{
    String endpoint = "/notice/create";
    //TODO: test the json.
    var response = await client.post(IpServer + ":" + Port + endpoint,body: jsonEncode(pojoCreateNotice));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Noticia creada con éxito.");
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


  //Get a List of the user's notices.
  Future<List<NoticeModel>> checkNotices() async{
    String endpoint = "/notice/checkNotices";

    var response = await client.get(IpServer + ":" + Port + endpoint);
    print("checkNotices");
    print(response.statusCode);
    print(response.body);
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


  //TODO: Deberia devolver un solo objeto, por eso existe el return dentro del for(), checkear
  Future<NoticeModel> getNoticeById(String id) async{
    String endpoint = "/notice/get";
    String params = "?id="+id;

    var response = await client.get(IpServer + ":" + Port + endpoint + params);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }

    var jsonData = json.decode(response.body);
    for (var n in jsonData){
      NoticeModel notice= new NoticeModel(n["_id"], n["title"], n["description"], n["author"], n["creationDate"], n["mails"], n["send"]);
      return notice;
    }
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
    print("Creado el usuario "+user.email);
  }


  Future<void> modifyUser(VUser user) async{
    String endpoint = "/user/modify";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(user));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Modificado el usuario "+user.email);
  }


  Future<void> modifyMyUser(VUser user) async{
    String endpoint = "/user/modifyMyUser";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(user));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Modificado el usuario "+user.email);
  }


  Future<void> setToken(String token) async{
    String endpoint = "/user/setToken";
    String params = "?token=" + token;

    var response = await client.post(IpServer + ":" + Port + endpoint + params);
    print("setToken");
    print(response.statusCode);
    print(response.body);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
  }


  Future<List<PojoUser>> getUsers() async {
    String endpoint = "/user/allUsers";
    var response = await client.get(IpServer + ":" + Port + endpoint);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    var jsonData = json.decode(response.body);
    print(jsonData);
    List<PojoUser> users= [];
    for(var n in jsonData){
      PojoUser user = new PojoUser(n["mail"],n["fullName"]);
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
      PojoUser user = new PojoUser(n["mail"],n["fullName"]);
      users.add(user);
    }
    return users;
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
    print("Tipo de Usuario "+type+" asignado al usuario "+mail+".");
  }


  Future<void> removeTypeToUser(String mail,String type) async{
    String endpoint = "/user/removeType";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(<String,String>{
      "string1":mail,
      "string2": type
    }));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Tipo de Usuario "+type+" removido del usuario "+mail+".");
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


  //Se pide code y description, ambos strings. Encuentra el code y le asigna el nuevo description.
  Future<void> modifyUserType(PojoUserType type) async{
    String endpoint = "/types/modify";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(type));
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Tipo de usuario modificado con éxito.");
  }
  

  Future<void> deactivateUserType(String code) async{
    String endpoint = "/types/deactivate";
    String params = "?code="+code;
    var response = await client.post(IpServer + ":" + Port + endpoint + params);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    print("Tipo de usuario desactivado con éxito.");
  }


  //TODO: una vez mas comprobar si trae un solo objeto.
  Future<PojoUser> getUserByMail(String mail) async{
    String endpoint = "/user/getUserByMail";
    String params = "?mail="+mail;
    var response = await client.get(IpServer + ":" + Port + endpoint+ params);
    if(response.statusCode != 200){
      throw new Exception("No se pudo conectar.");
    }
    var jsonData = json.decode(response.body);
    for(var n in jsonData){
      PojoUser user = new PojoUser(n["mail"],n["fullName"]);
      return user;
    }
  }
}