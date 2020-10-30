import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_analysis_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_notices_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_userTypes_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_users_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/administrator_menu.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';
import 'package:nick_tecnologia_notices/screens/edit_user_screen.dart';
import 'package:nick_tecnologia_notices/screens/login_screen_v3.dart';
import 'package:nick_tecnologia_notices/screens/notice.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo) {
      if(EasyLoading.instance.w != null){
        return true;
      }
      return false;
    });
    return CupertinoApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Holis"),
        ),
      ),
    );

  }
}