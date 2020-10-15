import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class AdminAnalysisMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AdminAnalysisMenuState();
  }

}
class AdminAnalysisMenuState extends State<AdminAnalysisMenu>{





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