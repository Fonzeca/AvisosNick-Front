import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/notice.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

class Notice extends StatefulWidget {
  bool admin;
  List<String> usuariosNotificados;
  String id_notice;

  Notice(this.id_notice, this.admin);


  @override
  State<StatefulWidget> createState() {
    if (admin) {
      return NoticeStateAdmin(id_notice);
    }
    return NoticeState(id_notice);
  }
}

class NoticeStateAdmin extends State<Notice> {
  String titulo, mensaje, autor, fecha;
  String id_notice;
  List<String> usuariosNotificados;
  NoticeModel noticeModel;

  ServidorRest _rest = ServidorRest();

  NoticeStateAdmin(this.id_notice);

  @override
  void initState() {
    super.initState();

    if(noticeModel == null){
      _rest.getNoticeById(id_notice).then((value){
        _markAsRead(value.id, value.readed);
        setState(() {
          noticeModel = value;
          titulo = value.title;
          mensaje = value.description;
          autor = value.author;
          fecha = value.creationDate;
          usuariosNotificados = value.mails;
        });

      });
    }
  }

  void _markAsRead(String id, bool readed){
    if(!readed){
      _rest.markNoticeAsRead(new PojoId(id)).then((value){

      }).catchError((e){
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    if(noticeModel == null){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Icon(Icons.auto_awesome,size: 48),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("En este momento no se encuentran noticias para usted.", style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
          ),
        ],
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Aviso"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  titulo,
                  style: fTitleNoticeOpen,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        mensaje,
                        textAlign: TextAlign.left,
                      )
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Fecha de creación: "),
                                Text(fecha, maxLines: 3,)
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Text("Escrita por: "),
                                Text(autor)
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Text("Enviado a: "),
                                _listUsuariosNotificados()
                              ],
                            )
                          ]
                        ),
                      ),
                    ),
                  )
                ),
              ]
            ),
          )
        )
      )
    );
  }

  Widget _listUsuariosNotificados() {
    if (usuariosNotificados == null || usuariosNotificados.isEmpty) {
      return Text("N/A");
    }
    return Container(
      height: 70,
      width: 200,
      child: ListView.builder(
          itemCount: usuariosNotificados.length,
          itemBuilder: (BuildContext context, index) {
            return _itemUsuarioNotificado(usuariosNotificados[index]);
          }),
    );
  }

  Widget _itemUsuarioNotificado(String usuario) {
    return Card(
      child: ListTile(
        title: Text(usuario),
      ),
    );
  }
}

class NoticeState extends State<Notice> {
  String titulo, mensaje, autor, fecha;
  String id_notice;
  NoticeModel noticeModel;

  ServidorRest _rest = ServidorRest();

  NoticeState(this.id_notice);

  @override
  void initState() {
    super.initState();

    if (noticeModel == null) {
      _rest.getNoticeById(id_notice).then((value) {
        _markAsRead(value.id, value.readed);
        setState(() {
          noticeModel = value;
          titulo = value.title;
          mensaje = value.description;
          autor = value.author;
          fecha = value.creationDate;
        });

      });
    }
  }

  void _markAsRead(String id, bool readed){
    if(!readed){
      _rest.markNoticeAsRead(new PojoId(id)).then((value){

      }).catchError((e){
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if(noticeModel == null){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Icon(Icons.auto_awesome,size: 48),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("En este momento no se encuentran noticias para usted.", style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Aviso"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  titulo,
                  style: fTitleNoticeOpen,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  flex: 9,
                  child: SingleChildScrollView(
                    child: Container(
                        width: double.infinity,
                        child: Text(
                          mensaje,
                          textAlign: TextAlign.left,
                        )),
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Fecha de creación: "),
                          Text(fecha)
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[Text("Escrita por: "), Text(autor)],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
