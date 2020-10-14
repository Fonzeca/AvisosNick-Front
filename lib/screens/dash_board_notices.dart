import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/model/notice.dart';
import 'file:///C:/Users/Alexis%20Fonzo/Desktop/FlutterProyects/nick_tecnologia_notices/lib/screens/administrator/administrator_menu.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:nick_tecnologia_notices/utilities/strings.dart';

import '../manager/api_calls.dart';
import 'notice.dart';

class DashBoardNotices extends StatefulWidget {
  @override
  _DashBoardNoticesState createState() => _DashBoardNoticesState();
}

class _DashBoardNoticesState extends State<DashBoardNotices> {
  List<String> itemsPopMenuBar = <String>[
    "Mi cuenta",
  ];
  ServidorRest _rest = ServidorRest();
  List<NoticeModel> noticiasOP = null;

  @override
  Widget build(BuildContext context) {
    if(noticiasOP == null){
      EasyLoading.show();
      _rest.checkNotices().then((value){
        EasyLoading.dismiss();
        setState((){
          noticiasOP = value;
        });
      }).catchError((e){
        EasyLoading.dismiss();
      });
    }

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
                Navigator.pop(context);
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

  Widget _buildBody() {
    if(noticiasOP == null || noticiasOP.isEmpty){
      return Text("No hay noticias para ti.");
    }

    List<Widget> widgets = new List();

    for (var notice in noticiasOP){
      widgets.add(_buildNotice(notice.title, notice.description));
    }
    return ListView(
      children: widgets,
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