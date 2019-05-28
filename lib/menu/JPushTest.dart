import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JPushTestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JPushTestState();
}

class _JPushTestState extends State<JPushTestPage> {
  @override
  Widget build(BuildContext context) {

    JPush jPush=new JPush();
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
      debug: false, // 设置是否打印 debug 日志
    );
    jPush.applyPushAuthority(new NotificationSettingsIOS(
        sound: true,
        alert: true,
        badge: true));
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('JPush Test'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: MaterialButton(
              onPressed: () {

              },
              child: ListTile(),
            ),
          ),
        ],
      ),
    );
  }
}
