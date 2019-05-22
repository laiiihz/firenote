import 'package:flutter/material.dart';
import 'home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/appModel.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: AppModel(),
      child: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
          return MaterialApp(
            title: 'fireNote',
            home: HomePage(),
            theme: model.appTheme,
          );
        },
      ),
    );
  }

}
