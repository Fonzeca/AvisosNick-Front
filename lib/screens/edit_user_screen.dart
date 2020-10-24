
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/model/user.dart';

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
  String emailUser;

  VUser vuser;

  String fullNameUser;

  List<String> userType;

  _EditUserState(this.isAdmin);

  void init(BuildContext context) {
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

    if(emailUser != null && emailUser.isNotEmpty && vuser != null){
      fullNameUser = vuser.fullName;
      userType = vuser.userType;
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
            _createInputText("Nombre completo", Icons.person, true, fullNameUser, setMail),
            _createListGridView(userType)
          ],
        ),
      ),
    );
  }

  Widget _createInputText(String label, IconData icon, bool enabled, String defaultValue, Function function){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: TextFormField(
        initialValue: defaultValue,
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

    return Column(
      children: [
        Container(
          child: Text("Tipos de usuario:", style: TextStyle(fontSize: 17, color: Colors.black87),),
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(vertical: 7),
        ),
        Container(
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
                    items[0],
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
        ),
      ],
    );
  }


  void setMail(String newValue){

  }

}