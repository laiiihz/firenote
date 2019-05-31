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

    Future<bool> transparentShared() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getBool('transparentMode' ?? false);
    }

    transparentShared().then((onValue) {
      model.setStatusBarTransparent(onValue ?? false);
    });

    Future<String> userNameShared() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getString('userName' ?? 'fireNote');
    }

    userNameShared().then((onValue) {
      model.setUserName(onValue ?? 'fireNote');
    });

    Future<bool> darkModeShared() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getBool('darkMode' ?? false);
    }

    darkModeShared().then((onValue) {
      model.setDarkMode(onValue ?? false);
      if (!(onValue ?? false)) {
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

    Future<List<String>> tagsShared() async{
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      return sharedPreferences.getStringList('tags')??['all'];
    }

    tagsShared().then((onValue){
      model.setTags(onValue);
    });

    new Future.delayed(Duration(milliseconds: 700), go2Home);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Container(
          color: Color(0x77ffffff),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/firenote.png',
                  width: 128,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
