import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/Notice/bloc/bloc_notice.dart';
import 'package:nick_tecnologia_notices/User/bloc/bloc_user.dart';
import 'package:nick_tecnologia_notices/routes.dart';
import 'file:///C:/Users/Alexis%20Fonzo/Desktop/FlutterProyects/nick_tecnologia_notices/lib/User/ui/screens/login_screen_v3.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

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
    BackButtonInterceptor.add((stopDefaultButtonEvent, routeInfo) {
      if(EasyLoading.instance.w != null){
        return true;
      }
      return false;
    });
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
      home: MultiProvider(
        providers: [
          Provider<NoticeBloc>.value(value: NoticeBloc()),
          Provider<UserBloc>.value(value: UserBloc()),
        ],
        child: LoginScreen(),
      ),
      routes: routesNick,
      builder: (BuildContext context, Widget child) {
        FlutterEasyLoading easyLoading = FlutterEasyLoading(child: child,);
        return easyLoading;
      },
    );
  }
}