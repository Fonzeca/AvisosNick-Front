import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/type.dart';

class AdminUserTypeMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AdminUserTypeMenuState();

}
class _AdminUserTypeMenuState extends State<AdminUserTypeMenu> {
  ServidorRest _servidorRest = ServidorRest();

  List<PojoUserType> tiposDeUsuario = null;


  String codeCreateType = "";
  String descriptionCreateType = "";

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
              Text("Lista de tipos"),
              Text("Crear tipo de usuario"),
            ],
          ),
          title: Text("Tipos de usuario"),
        ),
        body: TabBarView(
          children: [
            _buildListOfUserTypes(tiposDeUsuario),
            _createUserTypeTab()
          ],
        ),
      ),
    );
  }

  void init() {
    EasyLoading.show();
    if (tiposDeUsuario == null) {
      _servidorRest.getAllUserTypes().then((value) {
        setState(() {
          tiposDeUsuario = value;
        });
        EasyLoading.dismiss();
      }).catchError((e) {
        EasyLoading.showError(e.toString());
      });
    }
  }


  Widget _buildListOfUserTypes(List<PojoUserType> types) {
    if (types == null || types.isEmpty) {
      return Text(
          "No se encontraron tipos de usuario.", style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center);
    }

    return ListView.builder(
      itemCount: types.length,
      itemBuilder: (BuildContext context, index) {
        return _userTypeListItem(types[index]);
      },
    );
  }


  Widget _createUserTypeTab() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _createInputText("Código", Icons.code, "code"),
            _createInputText("Descripción", Icons.description, "description"),
            _buildSaveButton()
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(){
    return Container(
      width: double.infinity,
      child: RaisedButton(
          onPressed: () {
            if (saveButtonEnabled) {
              saveButtonEnabled = false;
              saveUserType();
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

  void saveUserType() {
    EasyLoading.show();
    _servidorRest.createUserType(PojoUserType(codeCreateType, descriptionCreateType))
        .then((value) {
          _fetchData(true);
      EasyLoading.showSuccess("Tipo de usuario guardado con éxito");

    }).catchError((e){
      EasyLoading.showError("Falló la carga del tipo de usuario", duration: Duration(seconds: 1));
      saveButtonEnabled = true;
    });
  }

  Widget _createInputText(String label, IconData icon, String field) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            prefixIcon: Icon(icon)
        ),
        onChanged: (value) {
          //TODO: Change this
          switch (field) {
            case "code":
              codeCreateType = value;
              break;
            case "description":
              descriptionCreateType = value;
              break;
          }
        },
      ),
    );
  }


  Widget _userTypeListItem(PojoUserType pojo) {
    return Card(
      child: ListTile(
        title: Text(pojo.code),
        subtitle: Text(pojo.description),
        trailing: FlatButton(
          minWidth: 0,
          onPressed: () {
            _deleteType(pojo.code);
          },
          child: Icon(Icons.delete),
        ),
      ),
    );
  }

  void _deleteType(String code){
    showDialog(context: context,
    builder: (_) => new AlertDialog(
      title: Text("¿Desactivar tipo de usuario?"),
      actions: <Widget>[
        FlatButton(onPressed:() {

        _deactivateType(code);
        Navigator.of(context).pop();
        },
            child: Text("Aceptar")),
        FlatButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("Cancelar"))
      ],
    )
    );
  }
  void _deactivateType (String code){
    EasyLoading.show();
    _servidorRest.deactivateUserType(code).then((value) {
      _fetchData(false);
      EasyLoading.showSuccess("Tipo de usuario desactivado con éxito.");
    }).catchError((e){
      EasyLoading.showError(e.toString());
    });
  }

  void _fetchData(bool guardar) async{
    if(guardar){

      saveButtonEnabled = true;
      limpiarFormulario();
    }
    tiposDeUsuario=null;
    init();
    return;
  }

  void limpiarFormulario(){
    codeCreateType = "";
    descriptionCreateType = "";
  }

}

