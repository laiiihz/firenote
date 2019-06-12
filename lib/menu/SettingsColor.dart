import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firenote/generated/i18n.dart';
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
            title: Text(S.of(context).theme_color),
          ),
          body: ListView(
            children: <Widget>[
              buildColor(Color(0xFFD4E157), S.of(context).lime),
              buildColor(Color(0xFF2196F3), S.of(context).blue),
              buildColor(Color(0xFFF06292), S.of(context).pink),
              buildColor(Color(0xFF4CAF50), S.of(context).light_green),
              buildColor(Color(0xFFF44336), S.of(context).red),
              buildColor(Color(0xFF9E9E9E), S.of(context).grey),
              buildColor(Color(0xFF03A9F4), S.of(context).light_blue),
              buildColor(Color(0xFF4CAF50), S.of(context).green),
              buildColor(Color(0xFF546E7A), S.of(context).blue_grey),
              buildColor(Color(0xFFFFC107), S.of(context).honey),
              buildColor(Color(0xFF673AB7), S.of(context).deep_purple),
              buildColor(Color(0xFF26A69A), S.of(context).teal),
              buildColor(Color(0xFFFFA726), S.of(context).orange),
              buildColor(Color(0xFFFF7043), S.of(context).dark_orange),
              buildColor(Color(0xFF26C6DA), S.of(context).blue_with_green),
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
