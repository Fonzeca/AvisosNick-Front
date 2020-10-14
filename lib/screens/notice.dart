import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

class Notice extends StatefulWidget {
  String titulo, mensaje, autor, fecha;

  Notice(String titulo, String mensaje, String autor, String fecha){
    this.titulo = titulo;
    this.mensaje = mensaje;
    this.autor = autor;
    this.fecha = fecha;
  }

  @override
  State<StatefulWidget> createState() {
    return NoticeState(titulo, mensaje, autor, fecha);
  }
}

class NoticeState extends State<Notice> {
  String titulo, mensaje, autor, fecha;

  NoticeState(String titulo, String mensaje, String autor, String fecha){
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
                      SizedBox(height: 20,),
                      Row(
                        children: <Widget>[
                          Text("Escrita por: "),
                          Text(autor)
                        ],
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
