import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'package:universal_io/prefer_universal/io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debugPaintSizeEnabled=false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final FirebaseMessaging messaging = FirebaseMessaging();

  MyApp(){
    if(!kIsWeb){
      messaging.requestNotificationPermissions();
      messaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          if(message.containsKey('data')){
            var data = message['data'];
            String id_notice = data['id_notice'];
            print("SE VIZUALIZA LA NOTICIA" + id_notice);
//            Navigator.push(context, MaterialPageRoute(builder: (context) => Notice(id_notice, false),));
          }
          print("onResume: $message");
        },
        onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      );
    }
  }
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print("onBackground: $message");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }


  @override
  Widget build(BuildContext context) {
    BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo) {
      if(EasyLoading.instance.w != null){
        return true;
      }
      return false;
    });
    return CupertinoApp(
      title: 'Avisos Nick',
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: nickPrimaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
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
      builder: (BuildContext context, Widget child) {
        FlutterEasyLoading easyLoading = FlutterEasyLoading(child: child,);
        return easyLoading;
      },
    );
  }


}