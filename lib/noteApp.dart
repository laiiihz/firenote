import 'package:flutter/material.dart';
import 'home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/appModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Splash.dart';

class NoteApp extends StatelessWidget {
  Future<bool> sharedDark() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('darkMode' ?? false);
  }
  @override
  Widget build(BuildContext context) {


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
