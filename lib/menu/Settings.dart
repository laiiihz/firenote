import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';
import 'package:firenote/menu/SettingsColor.dart';
import 'DeveloperMode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firenote/generated/i18n.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).pop_settings),
          ),
          body: ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(
                    model.isDarkModeOn
                        ? Icons.brightness_3
                        : Icons.brightness_7,
                    size: 35,
                  ),
                  title: Text(S.of(context).night_mode),
                  subtitle:
                      model.isDarkModeOn ? Text(S.of(context).night_mode_off) : Text(S.of(context).night_mode_on),
                  trailing: Switch(
                      value: model.isDarkModeOn,
                      onChanged: (value) {
                        model.setDarkMode(value);
                        _sharedDark() async {
                          SharedPreferences sh =
                              await SharedPreferences.getInstance();
                          sh.setBool('darkMode', value);
                        }

                        _sharedDark();
                      }),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    model.statusBarTransparent
                        ? Icons.fullscreen
                        : Icons.fullscreen_exit,
                    size: 35,
                  ),
                  title: Text(S.of(context).immersive_mode),
                  subtitle:
                  model.statusBarTransparent ? Text(S.of(context).immersive_mode_off) : Text(S.of(context).immersive_mode_on),
                  trailing: Switch(
                      value: model.statusBarTransparent,
                      onChanged: (value) {
                        model.setStatusBarTransparent(value);
                        _sharedDark() async {
                          SharedPreferences sh =
                          await SharedPreferences.getInstance();
                          sh.setBool('transparentMode', value);
                        }

                        _sharedDark();
                      }),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.invert_colors,
                    size: 35,
                    color: model.primaryColor,
                  ),
                  title: Text(S.of(context).theme_color),
                  subtitle:
                      model.isDarkModeOn ? Text(S.of(context).nulls) : Text(model.colorName),
                  trailing: MaterialButton(
                    onPressed: model.isDarkModeOn
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new SettingsColorPage()));
                          },
                    child: Text(model.colorName),
                    color: model.primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Card(
                child: MaterialButton(
                  child: ListTile(
                    leading: Icon(Icons.developer_mode),
                    title: Text(S.of(context).experiment_settings),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new DeveloperModePage()));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
