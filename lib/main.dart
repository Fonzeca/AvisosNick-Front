import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nick_tecnologia_notices/screens/administrator/admin_users_menu.dart';
import 'file:///C:/Users/Alexis%20Fonzo/Desktop/FlutterProyects/nick_tecnologia_notices/lib/screens/administrator/administrator_menu.dart';
import 'package:nick_tecnologia_notices/screens/dash_board_notices.dart';
import 'package:nick_tecnologia_notices/screens/login_screen_v3.dart';
import 'package:nick_tecnologia_notices/screens/notice.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:flutter/rendering.dart';

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
          print("onResume: $message");
        },
        onBackgroundMessage: myBackgroundMessageHandler,
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'OpenSans',
        primaryColor: nickPrimaryColor,
        primaryColorLight: nickPrimaryColorLight,
        primaryColorDark: nickPrimaryColorDark,
        accentColor: nickAccentColor,
      ),
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/dashBoard' : (BuildContext context) => new DashBoardNotices(),
        '/administrator' : (BuildContext context) => new AdministratorMenu(),
        '/administrator/usuarios' : (BuildContext context) => new AdminMenuUsuarios(),
        '/login' : (BuildContext context) => new LoginScreen(),
      },
    );
  }
}