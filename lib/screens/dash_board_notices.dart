import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/screens/administrator_menu.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:nick_tecnologia_notices/utilities/strings.dart';

import 'notice.dart';

class DashBoardNotices extends StatefulWidget {
  @override
  _DashBoardNoticesState createState() => _DashBoardNoticesState();
}

class _DashBoardNoticesState extends State<DashBoardNotices> {
  List<String> itemsPopMenuBar = <String>[
    "Mi cuenta",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Avisos"),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context){
              return itemsPopMenuBar.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: ExactAssetImage(
                      'assets/logos/nick.png',
                    scale: 1.8
                  ),
                  fit: BoxFit.none,
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      sDrawerHeaderLabelFirst,
                      style: nickTitleMayus
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        sDrawerHeaderLabelLast,
                        style: nickTitleMin,
                      ),
                    )
                  ],
                ),
              )
            ),
            ListTile(
              title: Text("Avisos"),
              leading: Icon(Icons.home, color: nickAccentColor,),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Recibos"),
              leading: Icon(Icons.assignment,color: nickAccentColor),
              onTap: (){

              },
            ),
            ListTile(
              title: Text("Administración"),
              leading: Icon(Icons.format_list_bulleted,color: nickAccentColor),
              onTap: (){
                Navigator.of(context).pushNamed('/administrator');
              },
            ),
            ListTile(
              title: Text("Salir"),
              leading: Icon(Icons.exit_to_app,color: nickAccentColor),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return ListView(
      children: <Widget>[
        _buildNotice("Horarios del retiro del recibo - Agosto", "El horario para retirar los recibos, será de 15hs a 18hs. Favor que todos los empleados se presenten en el rango de horario."),
        _buildNotice("Restricción en la entrada al predio", "Debidos a algunos violaciones al protocolo de salud por la cuarentena, se decidió sacarle la manija al portón de entrada del predio. El portón se mantendrá abierto de 07hs hasta las 08hs, y de 15hs hasta las 16hs."),
        _buildNotice("Medidas preventivas por el Covid-19", "Todos los empleados, antes de ingresar al predio, deberán ser escaneado por un sensor de temperatura. Al que tenga de más de 37 grados en temperatura corporal, se enviado a casa por 7 días."),
        _buildNotice("Nuevo horario de ingreso", "Los empleados que trabajen en Puerto San Julián, en el taller de Nick. El horario de entrada al lugar ahora es a las 07hs."),
      ],
    );
  }

  Widget _buildNotice(String titulo, String mensaje){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            title: Text(titulo, style: fTitleNoticeList,),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                mensaje,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text("VER MÁS", style: TextStyle(color: nickAccentColor, fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Notice(titulo, mensaje),));
                },
                color: nickPrimaryColorLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
            ],
          )
        ],
      ),
    );
  }

}