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
    Future<bool> darkModeShared() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getBool('darkMode' ?? false);
    }

    AppModel model = ScopedModel.of(context);
    darkModeShared().then((onValue) {
      model.setDarkMode(onValue ?? false);
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
