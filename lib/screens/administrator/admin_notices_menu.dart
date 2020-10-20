import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/type.dart';

class AdminNoticeMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AdminNoticeMenuState();
  }

}
class AdminNoticeMenuState extends State<AdminNoticeMenu> {
  ServidorRest _servidorRest = ServidorRest();
  List<PojoUserType> tiposDeUsuario = null;


  String title_createNotice = "";
  String message_createNotice = "";
  String userTypeCreateUser = "";

  bool checkSendNotification_createNotice = false;
  bool saveButtonEnabled = true;

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
    if(tiposDeUsuario == null){
      _servidorRest.getAllUserTypes().then((value) => {
        setState((){
          tiposDeUsuario = value;
        })
      }).catchError((e){
        EasyLoading.showError("Error");
      });
    }

    if(tiposDeUsuario != null){
      EasyLoading.dismiss();
    }
  }

  /**
   * Lista de noticias
   */
  Widget _listNoticesScreen() {
    return Text("No se encontraron avisos.", style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center);
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
              saveButtonEnabled = false;
              guardarNotice();
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



  }

}