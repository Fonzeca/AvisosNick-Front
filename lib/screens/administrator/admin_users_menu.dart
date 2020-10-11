import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/user.dart';

class AdminMenuUsuarios extends StatefulWidget {
  @override
  _AdminMenuUsuariosState createState() => _AdminMenuUsuariosState();
}
class _AdminMenuUsuariosState extends State<AdminMenuUsuarios> {
  ServidorRest _servidorRest = ServidorRest();
  List<PojoUser> users = null;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text("Lista de usuarios"),
              Text("Crear usuario"),
            ],
          ),
          title: Text("Menu de usuarios"),
        ),
        body: TabBarView(
          children: [
            _listaUsuariosScreen(),
            Center(child: Text("Segundo"),),
          ],
        ),
      ),
    );
  }

  Widget _listaUsuariosScreen(){
    if(users == null){
      _servidorRest.getUsers().then((value) => {
        setState(() => {
          users = value
        })
      });
      return Text("No hay usuarios");
    }

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, index){
          return _itemListaUsuario(users[index]);
        }
    );
  }

  Widget _itemListaUsuario(PojoUser user){
    return Card(
      child: ListTile(
        title: Text(user.email),
      ),
    );
  }

  Widget _createUserScreen(){
    
  }
}