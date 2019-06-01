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

    Future<bool> startAtOneShared()async{
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      return sharedPreferences.getBool('startAtOne'??true);
    }
    startAtOneShared().then((onValue){
      model.setStartAtOne(onValue);
    });


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
          String tempString = '蓝色';
          switch (color) {
            case 0xFFD4E157:
              tempString = 'lime';
              break;
            case 0xFF2196F3:
              tempString = '蓝色';
              break;
            case 0xFFF06292:
              tempString = '粉色';
              break;
            case 0xFF4CAF50:
              tempString = '亮绿色';
              break;
            case 0xFFF44336:
              tempString = '红色';
              break;
            case 0xFF9E9E9E:
              tempString = '灰色';
              break;
            case 0xFF03A9F4:
              tempString = '亮蓝色';
              break;
            case 0xFF4CAF50:
              tempString = '绿色';
              break;
            case 0xFF546E7A:
              tempString = '蓝灰色';
              break;
            case 0xFFFFC107:
              tempString = '蜂蜜色';
              break;
            case 0xFF673AB7:
              tempString = '深紫色';
              break;
            case 0xFF26A69A:
              tempString = '靛青';
              break;
            case 0xFFFFA726:
              tempString = '橘色';
              break;
            case 0xFFFF7043:
              tempString = '深橘色';
              break;
            case 0xFFA1887F:
              tempString = '棕色';
              break;
            case 0xFF26C6DA:
              tempString = '蓝绿色';
              break;
          }
          model.setPrimaryColor(
              Color(color ?? Colors.blue.value) ?? Colors.blue,
              tempString?? '蓝色');
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

    Future<List<String>> tagsShared() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getStringList('tags') ?? ['all'];
    }

    tagsShared().then((onValue) {
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
