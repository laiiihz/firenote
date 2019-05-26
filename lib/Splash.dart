import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/appModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  void go2Home() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppModel model = ScopedModel.of(context);

    Future<bool> darkModeShared() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getBool('darkMode' ?? false);
    }

    darkModeShared().then((onValue) {
      model.setDarkMode(onValue ?? false);
      if (!(onValue??false)) {
        Future<int> themeColorShared() async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          return sharedPreferences.getInt('themeColor' ?? Colors.blue.value);
        }

        themeColorShared().then((color) {
          model.setPrimaryColor(
              Color(color ?? Colors.blue.value) ?? Colors.blue,
              color.toString() ?? '蓝色');
        });
      }
    });

    Future<bool> iphoneModeShared() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getBool('iphoneMode' ?? false);
    }

    iphoneModeShared().then((onValue) {
      model.setIPhoneStyleOn(onValue ?? false);
    });

    new Future.delayed(Duration(milliseconds: 500), go2Home);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Container(
          child: Image.asset('assets/1.png'),
        );
      },
    );
  }
}
