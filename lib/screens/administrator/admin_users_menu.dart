import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/manager/login_in.dart';
import 'package:nick_tecnologia_notices/model/type.dart';
import 'package:nick_tecnologia_notices/model/user.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';

class AdminMenuUsuarios extends StatefulWidget {
  @override
  _AdminMenuUsuariosState createState() => _AdminMenuUsuariosState();
}
class _AdminMenuUsuariosState extends State<AdminMenuUsuarios> {
  ServidorRest _servidorRest = ServidorRest();

  List<PojoUser> users = null;
  List<PojoUserType> tiposDeUsuario = null;


  String emailCreateUser = "";
  String fullNameCreateUser = "";
  String passwordCreateUser = "";
  bool checkCreateUserAdmin = false;
  String userTypeCreateUser = "";

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
              Text("Lista de usuarios"),
              Text("Crear usuario"),
            ],
          ),
          title: Text("Menu de usuarios"),
        ),
        body: TabBarView(
          children: [
            _listaUsuariosScreen(),
            _createUserScreen()
          ],
        ),
      ),
    );
  }

  void init(){
    EasyLoading.show();
    if(users == null){
      _servidorRest.getUsers().then((value) => {
        setState(() {
          users = value;
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
        EasyLoading.showError(e.toString());
      });
    }

    if(users != null && tiposDeUsuario != null){
      EasyLoading.dismiss();
    }

  }

  /**
   * Listas de usuario
   */
  Widget _listaUsuariosScreen(){
    if(users == null || users.isEmpty){
      return Text("No se encontraron usuarios.", style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemCount: users.length,
      itemBuilder: (BuildContext context, index){
        return _itemListaUsuario(users[index]);
      }
    );
  }

  Widget _itemListaUsuario(PojoUser user){
    return Card(
      child: ListTile(
        title: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatButton(
              minWidth: 0,
              onPressed: () {
                Navigator.of(context).pushNamed('/administrator/usuarios/editUser', arguments: user.email);
              },
              child: Icon(Icons.edit),
            ),
            FlatButton(
              minWidth: 0,
              onPressed: () {
                _deleteUserModal(user.email);
              },
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUserModal(String email){
    showDialog(context: context,
      builder: (_) => new AlertDialog(
        title: Text("¿Desactivar usuario?"),
        actions: <Widget>[
          FlatButton(
            onPressed:() {
              //TODO: Hacer la funcionalidad para desactivar un usuario.
              _deactivateUser(email);
              Navigator.of(context).pop();
            },
            child: Text("Aceptar")),
          FlatButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text("Cancelar"))
        ],
      )
    );
  }

  void _deactivateUser(String mail){
    EasyLoading.show();
    _servidorRest.setUserActive(mail, false).then((value) {
      EasyLoading.showSuccess("Usuario desactivado con exito.");
    }).catchError((e){
      EasyLoading.showError(e.toString());
    });
  }

  /**
   * Creacion de usuario
   */
  Widget _createUserScreen(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _createInputText("Email", Icons.email, "email"),
            _createInputText("Nombre completo", Icons.person, "fullName"),
            _createInputText("Contraseña", Icons.lock, "password"),
            _createDropBoxSelector(tiposDeUsuario),
            _buildCheckAdmin(),
            _buildButtonSave()
          ],
        ),
      ),
    );
  }

  Widget _createInputText(String label, IconData icon, String field){
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
          switch(field){
            case "email":
              emailCreateUser = value;
              break;
            case "fullName":
              fullNameCreateUser = value;
              break;
            case "password":
              passwordCreateUser = value;
              break;
          }
        },
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

  Widget _buildCheckAdmin(){
    return Row(
      children: [
        Checkbox(
          value: checkCreateUserAdmin,
          onChanged: (value) {
            setState(() {
              checkCreateUserAdmin = value;
            });
          },
        ),
        Text("Administrador",)
      ],
    );
  }

  Widget _buildButtonSave(){
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          if(saveButtonEnabled){
            saveButtonEnabled = false;
            guardarUsuario();
          }
        },
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        color: Theme.of(context).accentColor,
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

  void guardarUsuario(){
    List<String> roles = List();
    roles.add(ROLE_USER);
    if(checkCreateUserAdmin){
      roles.add(ROLE_ADMIN);
    }

    //TODO: contemplar mas de un userType por usuario
    List<String> userTypes = List();
    userTypes.add(userTypeCreateUser);

    EasyLoading.show();
    _servidorRest.createUser(VUser(emailCreateUser, passwordCreateUser, fullNameCreateUser, roles, userTypes))
        .then((value) {
      EasyLoading.showSuccess("Usuario guardado");
      saveButtonEnabled = true;
      limpiarFormulario();
    }).catchError((e){
      EasyLoading.showError("No se pudo terminar la operacion", duration: Duration(seconds: 1));
      saveButtonEnabled = true;
    });
  }

  void limpiarFormulario(){
    emailCreateUser = "";
    fullNameCreateUser = "";
    passwordCreateUser = "";
    checkCreateUserAdmin = false;
    userTypeCreateUser = "";
  }
}