class PojoUserType{
  final String code;
  final String description;

  PojoUserType(this.code, this.description);

  Map<String, dynamic> toJson()=>{
    'code' : code,
    'description' : description
  };


}
class UserType{
  final String id;
  final String code;
  final String description;
  final String active;

  UserType(this.id, this.code, this.description, this.active);


}