import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

class Notice extends StatefulWidget {
  String titulo, mensaje, autor, fecha;
  bool admin;
  List<String> usuariosNotificados;

  Notice(String titulo, String mensaje, String autor, String fecha, bool admin,
      List<String> usuariosNotificados) {
    this.titulo = titulo;
    this.mensaje = mensaje;
    this.autor = autor;
    this.fecha = fecha;
    this.admin = admin;
    this.usuariosNotificados = usuariosNotificados;
  }

  @override
  State<StatefulWidget> createState() {
    if (admin) {
      return NoticeStateAdmin(
          titulo, mensaje, autor, fecha, usuariosNotificados);
    }
    return NoticeState(titulo, mensaje, autor, fecha);
  }
}

class NoticeStateAdmin extends State<Notice> {
  String titulo, mensaje, autor, fecha;
  List<String> usuariosNotificados;

  NoticeStateAdmin(this.titulo, this.mensaje, this.autor, this.fecha,
      this.usuariosNotificados);

  @override
  Widget build(BuildContext context) {
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
                      )
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 2,
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
                                Text("Usuarios notificados: "),
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
    return ListView.builder(
        itemCount: usuariosNotificados.length,
        itemBuilder: (BuildContext context, index) {
          return _itemUsuarioNotificado(usuariosNotificados[index]);
        });
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

  NoticeState(String titulo, String mensaje, String autor, String fecha) {
    this.titulo = titulo;
    this.mensaje = mensaje;
    this.autor = autor;
    this.fecha = fecha;
  }

  @override
  Widget build(BuildContext context) {
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
