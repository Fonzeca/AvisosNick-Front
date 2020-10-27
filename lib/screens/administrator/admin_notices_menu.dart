import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/notice.dart';
import 'package:nick_tecnologia_notices/model/type.dart';
import 'package:nick_tecnologia_notices/screens/notice.dart';

class AdminNoticeMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AdminNoticeMenuState();
  }

}
class AdminNoticeMenuState extends State<AdminNoticeMenu> {
  ServidorRest _servidorRest = ServidorRest();
  List<PojoUserType> tiposDeUsuario = null;
  List<NoticeModel> avisos = null;


  String title_createNotice = "";
  String message_createNotice = "";
  String userTypeCreateUser = "";

  bool checkSendNotification_createNotice = false;
  bool saveButtonEnabled = true;
  Map<String,String> additionalProp = Map<String,String>();
  MapEntry<String,String> newEntries = MapEntry<String,String>("click_action", "FLUTTER_NOTIFICATION_CLICK");


  @override
  Widget build(BuildContext context) {
    init();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text("Lista de avisos"),
              Text("Crear un aviso"),
            ],
          ),
          title: Text("Avisos"),
        ),
        body: TabBarView(
          children: [
            _listNoticesScreen(),
            _createNoticeScreen()
          ],
        ),
      ),
    );
  }

  void init() {
    EasyLoading.show();
    if(avisos == null){
      _servidorRest.getAllNotices().then((value) => {
        setState((){
          avisos = value;
        })
      }).catchError((e){
        EasyLoading.showError(e.toString());
      });
    }
    if(tiposDeUsuario == null){
      _servidorRest.getAllUserTypes().then((value) => {
        setState((){
          tiposDeUsuario = value;
        })
      }).catchError((e){
        EasyLoading.showError("Error");
      });
    }

    if(tiposDeUsuario != null||avisos != null ){

      EasyLoading.dismiss();
    }
  }

  /**
   * Lista de noticias
   */
  Widget _listNoticesScreen() {
    if(avisos==null||avisos.isEmpty){

      return Text("No se encontraron avisos.", style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center);
    }


    return ListView.builder(
      itemCount: avisos.length,
        itemBuilder:(BuildContext context, index){
        return _noticeListItem(avisos[index]);
    },
    );

  }

  Widget  _noticeListItem(NoticeModel pojo){
    return Card(
      child: ListTile(
        isThreeLine: true,
        title: Text(pojo.title),
        subtitle: Text(pojo.description, maxLines: 3,),
        trailing: FlatButton(
          minWidth: 0,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Notice(pojo.id, true),));
          },
          child: Icon(Icons.visibility),
        ),
      ),
    );
  }


  /**
   * Crear noticia
   */
  Widget _createNoticeScreen() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Titulo",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  prefixIcon: Icon(Icons.title)
              ),
              onChanged: (value) {
                title_createNotice = value;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 13,
              decoration: InputDecoration(
                  labelText: "Mensaje",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  prefixIcon: Icon(Icons.message)
              ),
              onChanged: (value) {
                message_createNotice = value;
              },
            ),
            SizedBox(height: 20,),
            _createDropBoxSelector(tiposDeUsuario),
            SizedBox(height: 20,),
            Row(
              children: [
                Checkbox(
                  value: checkSendNotification_createNotice,
                  onChanged: (value) {
                    setState(() {
                      checkSendNotification_createNotice = value;
                    });
                  },
                ),
                Text("Enviar notificacion"),
              ],
            ),
            SizedBox(height: 20,),
            _buildButtonSave(),
          ],
        ),
      ),
    );
  }


  Widget _buildButtonSave() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
          onPressed: () {
            if (saveButtonEnabled) {
              guardarNotice();
              saveButtonEnabled = false;
            }
          },
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          color: Theme
              .of(context)
              .accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            "GUARDAR",
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
    );
  }


  Widget _createDropBoxSelector(List<PojoUserType> items){
    if(items == null || items.isEmpty){
      return Text("No hay registros...", style: TextStyle(color: Colors.red),);
    }

    List<DropdownMenuItem<String>> itemsDropDown = items.map((e) => DropdownMenuItem<String>(child: Text(e.code), value: e.code,)).toList();

    if(userTypeCreateUser == null || userTypeCreateUser.isEmpty)
      userTypeCreateUser = itemsDropDown[0].value;

    return DropdownButton(
      value: userTypeCreateUser,
      items: itemsDropDown,
      onChanged: (Object value) {
        print(value);
        setState((){
          userTypeCreateUser = value;
        });
      },
    );
  }


  void guardarNotice() {
    EasyLoading.show();
    //TODO: mejorar para cuando haya mas de un tipo de usuario.
    List<String> types= new List<String>();
    types.add(userTypeCreateUser);


    additionalProp.putIfAbsent("click_action", () => "FLUTTER_NOTIFICATION_CLICK");

    PojoData data = PojoData(additionalProp);
    PojoCreateNotice pojoCreateNotice = PojoCreateNotice(types,null,checkSendNotification_createNotice,
      title_createNotice,message_createNotice,data);


    _servidorRest.createNotice(pojoCreateNotice).then((value){
      EasyLoading.showSuccess("Aviso creado con éxito.");

      _fetchData();

    }).catchError((e){
      EasyLoading.showError(e.toString(), duration: Duration(seconds: 3));
    });


  }
  Future<void> _fetchData() async{
    avisos=null;
    init();
    return;
  }

}