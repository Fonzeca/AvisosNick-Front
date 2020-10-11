
class VUser{
  final String email;
  final String password;
  final List<String> roles;
  final List<String> userType;

  VUser(this.email, this.password, this.roles, this.userType);


}
class PojoUser{
  final String email;
  final String fullName;

  PojoUser(this.email, this.fullName);
}