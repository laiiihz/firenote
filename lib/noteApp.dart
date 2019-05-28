import 'package:flutter/material.dart';
import 'home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/appModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Splash.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class NoteApp extends StatelessWidget {
  Future<bool> sharedDark() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('darkMode' ?? false);
  }
  @override
  Widget build(BuildContext context) {
    final JPush jPush=new JPush();
    Future<void> initPush()async{
      jPush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        // 点击通知回调方法。
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
        },
        // 接收自定义消息回调方法。
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
      jPush.setup(
        appKey: "6c3f37c8eb55fba38aa5ac72",
        channel: "theChannel",
        production: false,
        debug: true,
      );
    }
    initPush();


    return ScopedModel<AppModel>(
      model: AppModel(),
      child: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
          return MaterialApp(
            title: 'fireNote',
            home: SplashPage(),
            theme: model.appTheme,
            routes: <String, WidgetBuilder>{
              '/HomePage': (BuildContext context) => new HomePage()
            },
          );
        },
      ),
    );
  }
}
