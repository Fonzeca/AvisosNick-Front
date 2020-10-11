import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

class AdministratorMenu extends StatefulWidget {
  @override
  _AdministratorMenuState createState() => _AdministratorMenuState();
}

class _AdministratorMenuState extends State<AdministratorMenu> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Administración"),
      ),
      body: Fragment1(),
    );
  }
}

class Fragment1 extends StatefulWidget {
  @override
  _Fragment1State createState() => _Fragment1State();
}
class _Fragment1State extends State<Fragment1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 60.0),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildButton("Usuarios", Icons.person, "/administrator/usuarios"),
          _buildButton("Noticias", Icons.send, null),
          _buildButton("Tipos de usuario", Icons.assignment_ind, null),
          _buildButton("Análisis", Icons.analytics, null),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, String routeScreen) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(routeScreen),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50.0,
                  color: nickPrimaryColorLight,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff2a2a2a),
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(color: nickAccentColor, borderRadius: BorderRadius.circular(7)),
    );
  }
}

class AdminMenuUsuarios extends StatefulWidget {
  @override
  _AdminMenuUsuariosState createState() => _AdminMenuUsuariosState();
}
class _AdminMenuUsuariosState extends State<AdminMenuUsuarios> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text("primero"),
              Text("segundo"),
            ],
          ),
          title: Text("Menu de usuarios"),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Primero"),),
            Center(child: Text("Segundo"),),
          ],
        ),
      ),
    );
  }

  Widget _listaUsuarios(){

    return ListView.builder(
      itemCount: 30,
      itemBuilder: (BuildContext context, index){
        return null;
      }
    );
  }

  Widget _itemListaUsuario(){
    return Card();
  }

}