import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/type.dart';

class AdminUserTypeMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AdminUserTypeMenuState();
  }

}
class AdminUserTypeMenuState extends State<AdminUserTypeMenu>{
  ServidorRest _servidorRest = ServidorRest();

  List<PojoUserType> tiposDeUsuario = null;

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        title: Text("Tipos de usuario"),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: _buildListOfUserTypes(tiposDeUsuario)
      ),
    );
  }

  void init(){
    EasyLoading.show();
    if (tiposDeUsuario == null){
      _servidorRest.getAllUserTypes().then((value) {
        setState((){
          tiposDeUsuario = value;
        });
        EasyLoading.dismiss();
      }).catchError((e){
        EasyLoading.showError(e.toString());
      });
    }
  }
  Widget _buildListOfUserTypes (List<PojoUserType> types){
    if(types == null || types.isEmpty){
      return Text("No se encontraron tipos de usuario.", style: TextStyle(fontSize: 24), textAlign: TextAlign.center);
    }

    return ListView.builder(
      itemCount: types.length,
      itemBuilder: (BuildContext context, index){
        return _userTypeListItem(types[index]);
      },
    );
  }

}

Widget _userTypeListItem(PojoUserType pojo) {
  return Card(
    child: ListTile(
      title: Text(pojo.code),
      subtitle: Text(pojo.description),
  ),
  );
}