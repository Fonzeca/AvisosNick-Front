
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'file:///C:/Users/Alexis%20Fonzo/Desktop/FlutterProyects/nick_tecnologia_notices/lib/User/model/user.dart';

class EditUser extends StatefulWidget {
  final bool isAdmin;
  EditUser(this.isAdmin,);

  @override
  _EditUserState createState() => _EditUserState(isAdmin);
}

class _EditUserState extends State<EditUser> {
  final ServidorRest _servidorRest = ServidorRest();
  final bool isAdmin;

  String appBarText;
  bool saveButtonEnabled = true;
  List<String> userTypesAvailable;
  String userTypeCreateUser;
  bool needLoad = true;

  VUser vuser;

  String emailUser;
  String fullNameUser;
  List<String> userType;


  _EditUserState(this.isAdmin);

  void init(BuildContext context) {
    if(!needLoad){
      return;
    }
    EasyLoading.show();

    if(emailUser == null || emailUser.isEmpty){
      emailUser = ModalRoute.of(context).settings.arguments;
    }

    if(vuser == null){
      print(emailUser);
      _servidorRest.getUserByMail(emailUser).then((value){
        setState(() {
          vuser = value;
        });
      }).catchError((e){
        EasyLoading.showError(e.toString());
      });
    }

    if(isAdmin && userTypesAvailable == null){
      _servidorRest.getAllUserTypes().then((value){
        setState(() {
          userTypesAvailable = List<String>();
          value.map((e) => userTypesAvailable.add(e.code)).toList();
        });
      }).catchError((e){
        EasyLoading.showError(e.toString());
      });
    }

    if(emailUser != null && emailUser.isNotEmpty &&
    vuser != null &&
    (!isAdmin || userTypesAvailable != null)){
      fullNameUser = vuser.fullName;
      userType = vuser.userType;
      needLoad = false;
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _createInputText("Email", Icons.email, false, emailUser, null),
            _createInputText("Nombre completo", Icons.person, true, fullNameUser, setNameUser),
            isAdmin ?
            ListTile(
              title: _createDropBoxSelector(userTypesAvailable),
              trailing: GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  setState(() {
                    if(!userType.contains(userTypeCreateUser)){
                      userType.add(userTypeCreateUser);
                    }
                    userTypeCreateUser = "";
                  });
                },
              ),
            ) : SizedBox(),
            isAdmin ?
            Container(
              child: Text("Tipos de usuario:", style: TextStyle(fontSize: 17, color: Colors.black87),),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 7),
            ) : SizedBox(),
            isAdmin ?
            _createListGridView(userType) : SizedBox(),
            _buildButtonSave(guardarUsuario)
          ],
        ),
      ),
    );
  }

  Widget _createInputText(String label, IconData icon, bool enabled, String defaultValue, Function function){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: TextFormField(
      controller: TextEditingController(text: defaultValue),
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
            ),
            prefixIcon: Icon(icon)
        ),
        enabled: enabled,
        onChanged: (value) {
          function(value);
        },
      ),
    );
  }

  Widget _createListGridView(List<String> items){
    if(items == null){
      return Text("No hay registro",style: TextStyle(color: Colors.red),);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38
        ),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      height: 200,
      width: double.infinity,
      child: GridView.builder(
        physics: ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.35,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                items[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    items.remove(items[index]);
                  });
                },
                child: Icon(
                  Icons.delete,
                  size: 20,
                )
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonSave(Function function){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: RaisedButton(
          onPressed: () {
            if(saveButtonEnabled){
              saveButtonEnabled = false;
              function();
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

  Widget _createDropBoxSelector(List<String> items){
    if(items == null || items.isEmpty){
      return Text("No hay registros...", style: TextStyle(color: Colors.red),);
    }

    List<DropdownMenuItem<String>> itemsDropDown = items.map((e) => DropdownMenuItem<String>(child: Text(e), value: e,)).toList();

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

  void setNameUser(String newValue){
    fullNameUser = newValue;
  }

  void addUserType(String newValue){
    userType.add(newValue);
  }

  void guardarUsuario(){
    VUser vuser = VUser(emailUser, null, fullNameUser, null, userType );
    EasyLoading.show();
    if(isAdmin){
      _servidorRest.modifyUser(vuser).then((value){
        EasyLoading.dismiss();
        Navigator.of(context).pop();
      }).catchError((e){
        EasyLoading.showError(e.toString());
      });
    }else{
      _servidorRest.modifyMyUser(vuser).then((value){
        EasyLoading.dismiss();
        Navigator.of(context).pop();
      }).catchError((e){
        EasyLoading.showError(e.toString());
      });
    }
  }

}