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
  List<String> lectores = null;


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

    }else EasyLoading.showError("error");
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
            _viewReaders(pojo.id);
          },
          child: Icon(Icons.visibility),
        ),
      ),
    );
  }

  void _viewReaders(String id) {
    showDialog(context: context,
        builder: (_) =>
        new AlertDialog(
          title: Text("Lista de usuarios notificados"),
          content: _listOfReaders(id),
        )
    );
  }

  
Widget _listOfReaders(String id) {
    EasyLoading.show();
  if(lectores == null){
    PojoId pojoId =PojoId(id);
    _servidorRest.getNoticeReaders(pojoId).then((value){
      setState(() {
        lectores=value;
      });
      EasyLoading.dismiss();
    }).catchError((e){
      EasyLoading.showError(e.toString() );
    });


  }
  return _buildListOfReaders(lectores);
  }

Widget _buildListOfReaders (List<String> lectores) {
  if (lectores == null || lectores.isEmpty){
    return Text(
      "El aviso aún no ha sido leído.",style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center);
  }

  return ListView.builder(
      itemCount: lectores.length,
      itemBuilder: (BuildContext context, index){
        return _readerListItem(lectores[index]);
      },
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

