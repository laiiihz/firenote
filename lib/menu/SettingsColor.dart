import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';

class SettingsColorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsColorState();
}

class _SettingsColorState extends State<SettingsColorPage> {
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
              buildColor(Colors.blue, '蓝色'),
              buildColor(Colors.pink, '粉色'),
              buildColor(Colors.green, '绿色'),
              buildColor(Colors.red, '红色'),
              buildColor(Colors.grey, '灰色'),
              buildColor(Colors.lightBlue, '亮蓝色'),
              buildColor(Colors.lightGreen, '亮绿色'),
              buildColor(Colors.blueGrey, '蓝灰色'),
              buildColor(Colors.amber, '蜂蜜色'),
              buildColor(Colors.deepPurple, '深紫色'),
              buildColor(Colors.indigo, '靛青'),
              buildColor(Colors.orange, '橘色'),
              buildColor(Colors.deepOrange, '深橘色'),
              buildColor(Colors.brown, '棕色'),
              buildColor(Colors.cyan, '蓝绿色'),
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
              style: TextStyle(color: color,fontSize: 20),
            ),
            trailing: RaisedButton(
              onPressed: () {
                model.setPrimaryColor(color,colorName);

              },
              color: color,
            ),
          ),
        );
      },
    );
  }
}
