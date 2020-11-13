import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_analysis_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_notices_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_userTypes_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_users_menu.dart';
import 'package:nick_tecnologia_notices/screens/administrator/administrator_menu.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';
import 'package:nick_tecnologia_notices/screens/edit_user_screen.dart';
import 'package:nick_tecnologia_notices/screens/login_screen_v3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: LoginScreen(),
      routes: {
      '/dashBoard' : (BuildContext context) => new DashBoardNotices(),
      '/administrator' : (BuildContext context) => new AdministratorMenu(),
      '/myAccount' : (BuildContext context) => new EditUser(false),
      '/administrator/usuarios' : (BuildContext context) => new AdminMenuUsuarios(),
      '/administrator/usuarios/editUser' : (BuildContext context) => new EditUser(true),
      '/administrator/userTypes' : (BuildContext context) => new AdminUserTypeMenu(),
      '/administrator/notices' : (BuildContext context) => new AdminNoticeMenu(),
      '/administrator/analysis' : (BuildContext context) => new AdminAnalysisMenu(),
      '/login' : (BuildContext context) => new LoginScreen(),
    },
    );

  }
}