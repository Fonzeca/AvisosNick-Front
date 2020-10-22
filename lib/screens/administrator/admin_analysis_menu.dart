import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/notice.dart';


class AdminAnalysisMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>  _AdminAnalysisMenuState();

}
class _AdminAnalysisMenuState extends State<AdminAnalysisMenu>{
  ServidorRest _servidorRest = ServidorRest();

  List<NoticeModel> avisos = null;


  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        title: Text("Análisis"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: _buildListOfNotices(avisos),
      ),
    );
  }


  void init() {
    EasyLoading.show();
    if(avisos == null){
      _servidorRest.getAllNotices().then((value){
        setState(() {
          avisos = value;
        });
        EasyLoading.dismiss();
      }).catchError((e){
        EasyLoading.showError(e.toString());
      });

    }
  }

  Widget _buildListOfNotices(List<NoticeModel> notices) {
    if (notices == null || notices.isEmpty) {
      return Text(
          "No se encontraron avisos.", style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center);
    }

    return ListView.builder(
      itemCount: notices.length,
      itemBuilder: (BuildContext context, index){
        return _noticeListItem(notices[index]);
      },
    );
  }

  Widget _noticeListItem(NoticeModel pojo) {
    return Card(
      child: ListTile(
        title: Text(pojo.title),
        subtitle: Text(pojo.description),
        trailing: FlatButton(
          minWidth: 0,
          onPressed: () {
            print("id del pojo");
            print(pojo.id);
            _callReaders(pojo.id);
          },
          child: Icon(Icons.visibility),
        ),
      ),
    );
  }

  void _viewReaders(List<String> lectores) {
    showDialog(context: context,
        builder: (_) =>
        new AlertDialog(
          title: Text("Lista de usuarios notificados"),
          content: _buildListOfReaders(lectores),
        )
    );
  }


  void _callReaders(String id) {
    EasyLoading.show();
    PojoId pojoId = PojoId(id);
    _servidorRest.getNoticeReaders(pojoId).then((value){
      _viewReaders(value);
      EasyLoading.dismiss();
    });
  }

Widget _buildListOfReaders (List<String> lectores) {
  if (lectores == null || lectores.isEmpty){
    return Text(
      "El aviso aún no ha sido leído.",style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center);
  }

  return Container(
    height: 300,
    width: 150,
    child: ListView.builder(
        itemCount: lectores.length,
        itemBuilder: (BuildContext context, index){
          return _readerListItem(lectores[index]);
        },
    ),
  );
}

Widget _readerListItem(String pojo){
    return Card(
      child: ListTile(
        title: Text(pojo),
      ),
    );
}
}

