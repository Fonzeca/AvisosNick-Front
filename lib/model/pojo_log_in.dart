import 'dart:convert';

class PojoLogIn {


  final String token;
  final String mail;
  final String fullName;
  final List<String> roles;
  final List<String> userType;


  PojoLogIn(
      this.token, this.mail, this.fullName, this.roles, this.userType);

  PojoLogIn.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        mail = json['mail'],
        fullName = "",
        roles = List<String>.from(json['roles']),
        userType = List<String>.from(json['userType']);

  Map<String, dynamic> toJson()=>{
    'token' : token,
    'email' : mail,
    'fullName' : fullName,
    'roles' : roles,
    'userType' : userType
  };
}