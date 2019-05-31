import 'package:firenote/model/appModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends State<TestPagePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          body: Center(
            child: RaisedButton(
              onPressed: () {
                List<String> testListString=['qwer',  'awgaw'];
                testSetTags() async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences
                      .setStringList('tags', testListString);
                }
                testSetTags().then((onValue){
                  model.setTags(testListString);
                });
              },
              color: model.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
