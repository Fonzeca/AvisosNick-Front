import 'package:flutter/material.dart';

import 'Notice/ui/screens/admin_menu/admin_analysis_menu.dart';
import 'Notice/ui/screens/admin_menu/admin_notices_menu.dart';
import 'Notice/ui/screens/dash_board_notices.dart';
import 'User/ui/screens/admin_menu/admin_userTypes_menu.dart';
import 'User/ui/screens/admin_menu/admin_users_menu.dart';
import 'User/ui/screens/administrator_menu.dart';
import 'User/ui/screens/edit_user_screen.dart';
import 'User/ui/screens/login_screen_v4.dart';


Map<String, WidgetBuilder> routesNick = {
  '/dashBoard' : (BuildContext context) => new DashBoardNotices(),
  '/administrator' : (BuildContext context) => new AdministratorMenu(),
  '/myAccount' : (BuildContext context) => new EditUser(false),
  '/administrator/usuarios' : (BuildContext context) => new AdminMenuUsuarios(),
  '/administrator/usuarios/editUser' : (BuildContext context) => new EditUser(true),
  '/administrator/userTypes' : (BuildContext context) => new AdminUserTypeMenu(),
  '/administrator/notices' : (BuildContext context) => new AdminNoticeMenu(),
  '/administrator/analysis' : (BuildContext context) => new AdminAnalysisMenu(),
  '/login' : (BuildContext context) => new LoginScreen(),
};