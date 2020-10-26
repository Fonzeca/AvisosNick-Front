import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nick_tecnologia_notices/manager/mindia_http_client.dart';
import 'package:nick_tecnologia_notices/model/notice.dart';
import 'package:nick_tecnologia_notices/model/pojo_log_in.dart';
import 'package:nick_tecnologia_notices/model/type.dart';
import 'package:nick_tecnologia_notices/model/user.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:universal_io/io.dart';

import 'login_in.dart';

class ServidorRest {
  final client = MindiaHttpClient(http.Client());
  final String IpServer = "http://vps-1791261-x.dattaweb.com";
  final String Port = "45589";

  Future<bool> login(String email, String password) async {
    String endpoint = "/login";
    String requestParam = "?email=" + email + "&password=" + password;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    print("Login Basic/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      return false;
    }
    //Parseamos el json al object
    Map pojoMap = jsonDecode(response.body);
    PojoLogIn pojoLogIn = PojoLogIn.fromJson(pojoMap);


    MindiaHttpClient.setPojoLogin(pojoLogIn, LOGIN_TYPE_NORMAL);
    return true;
  }

  Future<bool> loginWithGoogle(String idTokenOAuth) async {
    String endpoint = "/loginWithGoogle";
    String requestParam = "?idToken=" + idTokenOAuth;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    print("Login Google/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      return false;
    }
    //Parseamos el json al object
    Map pojoMap = jsonDecode(response.body);
    PojoLogIn pojoLogIn = PojoLogIn.fromJson(pojoMap);

    MindiaHttpClient.setPojoLogin(pojoLogIn, LOGIN_TYPE_GOOGLE);
    return true;
  }

  Future<bool> loginWithFacebook(String idTokenOAuth) async {
    String endpoint = "/loginWithFacebook";
    String requestParam = "?idToken=" + idTokenOAuth;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    print("Login Facebook/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      return false;
    }
    //Praseamos el json al object
    Map pojoMap = jsonDecode(response.body);
    PojoLogIn pojoLogIn = PojoLogIn.fromJson(pojoMap);

    MindiaHttpClient.setPojoLogin(pojoLogIn, LOGIN_TYPE_FACEBOOK);
    return true;
  }

  Future<bool> validateToken([bool loginSiently = true]) async{
    String endpoint = "/validateToken";
    //TODO: preguntar si existe un token, antes de validar

    var response = await client.get(IpServer + ":" + Port + endpoint);

    print("validateToken/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.body.isNotEmpty && response.body == "true"){
      return true;
    }else{
      if(loginSiently && await signInSilently()){
        return await validateToken(false);
      }
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

    print("createNotice/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print("Noticia creada con éxito.");
  }

  Future<void> markNoticeAsRead(PojoId pojoId) async{
    String endpoint = "/notice/markAsRead";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoId));

    print("markNoticeAsRead/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print(pojoId.id);
  }

  Future<void> deactivateNotice(PojoId pojoId) async{
    String endpoint = "/notice/deactivate";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoId));

    print("deactivateNotice/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print(pojoId.id);
  }

  Future<void> modifyNotice(PojoModifyNotice pojoModifyNotice) async{
    String endpoint = "/notice/modify";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoModifyNotice));

    print("modifyNotice/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print(pojoModifyNotice.title);
  }

  Future<List<String>> getNoticeReaders(PojoId pojoId) async{
    String endpoint = "/notice/readedBy";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(pojoId));

    print("getNoticeReaders/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }

    var jsonData = json.decode(response.body);
    List<String> readers= [];
    for(var n in jsonData){
      readers.add(n);
    }
    return readers;
  }

  //Get a List of the user's notices.
  Future<List<NoticeModel>> checkNotices() async{
    String endpoint = "/notice/checkNotices";

    var response = await client.get(IpServer + ":" + Port + endpoint);

    print("checkNotices/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }

    var jsonData = json.decode(response.body);
    List<NoticeModel> notices= [];
    for(var n in jsonData){
      NoticeModel notice = new NoticeModel(n["id"],n["title"],n["description"],
          n["author"],n["creationDate"],n["mails"]);
      notices.add(notice);
    }
    return notices;

  }

  //Get a List with all the current notices.
  Future<List<NoticeModel>> getAllNotices() async{
    String endpoint = "/notice/getAll";

    var response = await client.get(IpServer + ":" + Port + endpoint);

    print("getAllNotices/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }

    var jsonData = json.decode(response.body);
    List<NoticeModel> notices = [];
    for(var n in jsonData){

      NoticeModel notice = NoticeModel.fromJson(n);
      notices.add(notice);
    }
    return notices;
  }

  Future<NoticeModel> getNoticeById(String id) async{
    String endpoint = "/notice/get";
    String params = "?id="+id;

    var response = await client.get(IpServer + ":" + Port + endpoint + params);

    print("getNoticeById/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }

    var n = json.decode(response.body);
    NoticeModel notice= new NoticeModel(n["id"], n["title"], n["description"], n["author"],
        n["creationDate"], n["mails"]);
    return notice;
  }


  /**
   * User api calls
   */

  Future<bool> createUser(VUser user) async{
    String endpoint = "/user/create";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(user));

    print("createUser/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    return true;
  }

  Future<void> modifyUser(VUser user) async{
    String endpoint = "/user/modify";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(user));

    print("modifyUser/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print("Modificado el usuario "+user.email);
  }

  Future<void> modifyMyUser(VUser user) async{
    String endpoint = "/user/modifyMyUser";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(user));

    print("modifyMyUser/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print("Modificado el usuario "+user.email);
  }

  Future<void> setToken(String token) async{
    String endpoint = "/user/setToken";
    String params = "?token=" + token;

    var response = await client.post(IpServer + ":" + Port + endpoint + params);

    print("setToken/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
  }

  Future<List<PojoUser>> getUsers() async {
    String endpoint = "/user/allUsers";
    var response = await client.get(IpServer + ":" + Port + endpoint);

    print("getUsers/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
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

    print("getUsersByType/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
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

    print("setTypeToUser/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
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

    print("removeTypeToUser/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print("Tipo de Usuario "+type+" removido del usuario "+mail+".");
  }

  Future<VUser> getUserByMail(String mail) async{
    String endpoint = "/user/getUserByMail";
    String params = "?mail="+mail;
    var response = await client.get(IpServer + ":" + Port + endpoint+ params);

    print("getUserByMail/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        return await getUserByMail(mail);
      }
      throw new Exception("No se pudo conectar.");
    }
    var n = json.decode(response.body);
    VUser user = VUser.fromJson(n);
    return user;
  }

  Future<void> setUserActive(String email, bool active) async{
    String endpoint = "/user/setActive";
    String params = "?email="+email + "&active=" + active.toString();
    var response = await client.post(IpServer + ":" + Port + endpoint+ params);

    print("setActive/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);

      }
      throw new Exception("No se pudo conectar.");
    }
  }

  /**
   * UserType api calls
   */

  Future<bool> createUserType(PojoUserType type) async{
    String endpoint = "/types/create";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(type));

    print("createUserType/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    return true;
  }

  Future<List<PojoUserType>> getAllUserTypes() async{
    String endpoint = "/types/allTypes";
    var response = await client.get(IpServer + ":" + Port + endpoint);

    print("getAllUserTypes/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    var jsonData = json.decode(response.body);
    List<PojoUserType> types = [];
    for(var n in jsonData){
      PojoUserType type = new PojoUserType(n["code"],n["description"]);
      types.add(type);
    }
    return types;
  }

  //Se pide code y description, ambos strings. Encuentra el code y le asigna el nuevo description.
  Future<void> modifyUserType(PojoUserType type) async{
    String endpoint = "/types/modify";
    var response = await client.post(IpServer + ":" + Port + endpoint, body: jsonEncode(type));

    print("modifyUserType/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);
        
      }
      throw new Exception("No se pudo conectar.");
    }
    print("Tipo de usuario modificado con éxito.");
  }

  Future<void> deactivateUserType(String code) async{
    String endpoint = "/types/deactivate";
    String params = "?code="+code;
    var response = await client.post(IpServer + ":" + Port + endpoint + params);

    print("deactivateUserType/ Status: " + response.statusCode.toString() + " Body: " + response.body);

    if(response.statusCode != 200){
      if(response.statusCode == 401){
        await validateToken(true);

      }
      throw new Exception("No se pudo conectar.");
    }
    print("Tipo de usuario desactivado con éxito.");
  }
}