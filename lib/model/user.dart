
class VUser{
  final String email;
  final String password;
  final List<String> roles;
  final List<String> userType;

  VUser(this.email, this.password, this.roles, this.userType);


}
class PojoUser{
  final String email;
  final String uniqueMobileToken;
  final List<String> roles;
  final List<String> userType;

  PojoUser(this.email, this.uniqueMobileToken, this.roles, this.userType);
}