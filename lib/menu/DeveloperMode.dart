import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DeveloperModePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeveloperModeState();
}

class _DeveloperModeState extends State<DeveloperModePage> {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('test notification'),
            content: Text('im the content'),
          ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var initAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initIOSSettings = IOSInitializationSettings();
    var initSetting =
        InitializationSettings(initAndroidSettings, initIOSSettings);
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onSelectNotification: onSelectNotification,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('实验性功能'),
                  background: Icon(
                    Icons.developer_mode,
                    size: 200,
                    color: Color(0x66ffffff),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Card(
                      child: ListTile(
                        leading: Icon(
                          model.iphoneStyleOn
                              ? Icons.phone_iphone
                              : Icons.phone_android,
                          size: 30,
                        ),
                        title: Text('应用风格'),
                        subtitle: model.iphoneStyleOn
                            ? Text('IOS style')
                            : Text('Android style'),
                        trailing: Switch(
                          value: model.iphoneStyleOn,
                          onChanged: (value) {
                            model.setIPhoneStyleOn(value);
                            openIPhoneMode() async {
                              SharedPreferences sh =
                                  await SharedPreferences.getInstance();
                              sh.setBool('iphoneMode', value);
                            }

                            openIPhoneMode();
                          },
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(
                          model.iphoneStyleOn
                              ? Icons.phone_iphone
                              : Icons.phone_android,
                          size: 30,
                        ),
                        title: Text('nav color'),
                        subtitle:
                            model.iphoneStyleOn ? Text('null') : Text('null'),
                        trailing: Switch(
                          value: model.navColorPaint,
                          onChanged: (value) {
                            model.setNavigatorColorPaint(
                                value, model.primaryColor);
                          },
                        ),
                      ),
                    ),
                    Card(
                      child: MaterialButton(
                        onPressed: () {
                          var androidSpecific = AndroidNotificationDetails(
                            'tech.laihz.firenote',
                            'laihz_notificate',
                            'here is the desc',
                            importance: Importance.Max,
                            priority: Priority.High,
                          );
                          var iOSSpecific = IOSNotificationDetails();
                          var platformSpecific =
                              NotificationDetails(androidSpecific, iOSSpecific);
                          _notificationMe() async {
//                            await _flutterLocalNotificationsPlugin.show(
//                              0,
//                              'im the title',
//                              'im the body',
//                              platformSpecific,
//                              payload: 'im the payload',
//                            ); //即时通知
                            print('time now:%%%%%%%%%%%%%%');
                            print(DateTime.now());
                            print(DateTime.now().add(Duration(seconds: 5)));
                            var timeMake=DateTime.now().add(Duration(seconds: 5));
                            await _flutterLocalNotificationsPlugin.schedule(
                              3000,
                              'im on time title',
                              'im on time body',
                              timeMake,
                              platformSpecific,
                              payload: 'im the payload',
                            );
                          }

                          _notificationMe();
                        },
                        child: ListTile(
                          leading: Icon(Icons.notifications_active),
                          title: Text('Notification Test'),
                          subtitle: Text('null'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
