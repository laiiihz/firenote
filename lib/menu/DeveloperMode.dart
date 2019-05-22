import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';
class DeveloperModePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeveloperModeState();
}


class _DeveloperModeState extends State<DeveloperModePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              snap: false,
              expandedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('实验性功能'),
                background: Icon(Icons.developer_mode,size: 200,color: Color(0x66ffffff),),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(<Widget>[
              Card(
                child: ListTile(
                  leading: Icon(model.iphoneStyleOn?Icons.phone_iphone:Icons.phone_android,size: 30,),
                  title: Text('应用风格'),
                  subtitle: model.iphoneStyleOn?Text('IOS style'):Text('Android style'),
                  trailing: Switch(value: model.iphoneStyleOn, onChanged: (value) {model.setIPhoneStyleOn(value);},),
                ),
              ),
            ])),
          ],
        ),
      );
    },

    );
  }
}
