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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Usuarios", Icons.person, "/administrator/usuarios"),
                  _buildButton("Avisos", Icons.send, "/administrator/notices"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Tipos de usuario", Icons.assignment_ind, "/administrator/userTypes"),
                  _buildButton("Análisis", Icons.analytics, "/administrator/analysis"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, String routeScreen) {
    double screen_size = MediaQuery.of(context).size.width >= 500 ? 500 :  MediaQuery.of(context).size.width ;
    double tam = screen_size/ 2 -10-20;

    return Container(
      height: tam,
      width: tam,
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
