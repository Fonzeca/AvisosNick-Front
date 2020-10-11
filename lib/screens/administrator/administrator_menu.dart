import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/user.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

class AdministratorMenu extends StatefulWidget {
  @override
  _AdministratorMenuState createState() => _AdministratorMenuState();
}

class _AdministratorMenuState extends State<AdministratorMenu> {
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
