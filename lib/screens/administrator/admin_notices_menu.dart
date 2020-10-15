import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';

class AdminNoticeMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AdminNoticeMenuState();
  }

}
class AdminNoticeMenuState extends State<AdminNoticeMenu>{



  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        title: Text("Avisos"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,

      ),
    );
  }

  void init() {
    EasyLoading.show();
    if(true){
      EasyLoading.dismiss();

    }else EasyLoading.showError("error");
  }


}