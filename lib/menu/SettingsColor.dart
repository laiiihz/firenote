import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsColorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsColorState();
}

class _SettingsColorState extends State<SettingsColorPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('主题色'),
          ),
          body: ListView(
            children: <Widget>[
              buildColor(Color(0xFFD4E157), 'lime'),
              buildColor(Color(0xFF2196F3), '蓝色'),
              buildColor(Color(0xFFF06292), '粉色'),
              buildColor(Color(0xFF4CAF50), '亮绿色'),
              buildColor(Color(0xFFF44336), '红色'),
              buildColor(Color(0xFF9E9E9E), '灰色'),
              buildColor(Color(0xFF03A9F4), '亮蓝色'),
              buildColor(Color(0xFF4CAF50), '绿色'),
              buildColor(Color(0xFF546E7A), '蓝灰色'),
              buildColor(Color(0xFFFFC107), '蜂蜜色'),
              buildColor(Color(0xFF673AB7), '深紫色'),
              buildColor(Color(0xFF26A69A), '靛青'),
              buildColor(Color(0xFFFFA726), '橘色'),
              buildColor(Color(0xFFFF7043), '深橘色'),
              buildColor(Color(0xFFA1887F), '棕色'),
              buildColor(Color(0xFF26C6DA), '蓝绿色'),
            ],
          ),
        );
      },
    );
  }

  Widget buildColor(Color color, String colorName) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Card(
          child: ListTile(
            title: Text(
              colorName,
              style: TextStyle(color: color, fontSize: 20),
            ),
            trailing: RaisedButton(
              onPressed: () {
                model.setPrimaryColor(color, colorName);
                _sharedColor() async {
                  SharedPreferences sh = await SharedPreferences.getInstance();
                  sh.setInt('themeColor', color.value);
                }

                _sharedColor();
              },
              color: color,
            ),
          ),
        );
      },
    );
  }
}
