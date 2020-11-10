
class VUser{
  final String email;
  final String password;
  final String fullName;
  final List<String> roles;
  final List<String> userType;

  VUser(this.email, this.password, this.fullName, this.roles, this.userType);

  Map<String, dynamic> toJson() =>{
    'email' : email,
    'password' : password,
    'fullName' : fullName,
    'roles' : roles,
    'userType' : userType
  };

  VUser.fromJson(Map<String, dynamic> json):
        email = json['email'],
        password = "",
        fullName = json['fullName'],
        roles = List<String>.from(json['roles']),
        userType = List<String>.from(json['userType']);
}

class PojoUser{
  final String email;
  final String fullName;

  PojoUser(this.email, this.fullName);
}