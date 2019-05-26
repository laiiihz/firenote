import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'menu/About.dart';
import 'menu/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/appModel.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/MainDatabase.dart';
import 'Edit/StandardEditor.dart';
import 'dart:math';
import 'Edit/EditorWithKey.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

enum _menuValue { about, settings }

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  ///*** DATABASE***/

  NoteProvider _noteProvider = NoteProvider();

  /// *DATABASE***/

  bool _floatingIsOpened = false;
  AnimationController _animationController;
  Animation<double> _animateIcon;
  Animation<Color> _animateColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;

  List<Widget> widgetNotes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppModel model = ScopedModel.of(context);
    getPath() async {
      var databasePath = await getDatabasesPath();
      var me = _noteProvider.open(Path.join(databasePath, 'app-0-1.db'));
      List<FireNote> tempNotes = [];
      me.then((value) async {
        tempNotes = await _noteProvider.getAllNote();
      }).then((n) {
        FireNote tempNote = FireNote();
        tempNote.color = 0x33ffffff;
        tempNote.text = '右下角点击开始新建';
        tempNote.id = 9999999;
        tempNote.title = '欢迎使用';
        if (tempNotes == null) {
          tempNotes = [tempNote];
          model.setNotes(tempNotes);
        } else
          model.setNotes(tempNotes);
      });
    }

    getPath();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });

    _animateIcon =
        Tween<double>(begin: 0.0, end: 1).animate(_animationController);

    _animateColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          0.5,
          curve: _curve,
        ),
      ),
    );

    _translateButton = Tween<double>(
      begin: 100,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.5,
        curve: _curve,
      ),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  animate() {
    if (!_floatingIsOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _floatingIsOpened = !_floatingIsOpened;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('FireNote'),
            actions: <Widget>[
              PopupMenuButton(
                tooltip: '菜单',
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<_menuValue>>[
                      PopupMenuItem<_menuValue>(
                        value: _menuValue.settings,
                        child: Text('设置'),
                      ),
                      PopupMenuItem<_menuValue>(
                        value: _menuValue.about,
                        child: Text('关于'),
                      ),
                    ],
                onSelected: (menuValue) {
                  switch (menuValue) {
                    case _menuValue.settings:
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SettingsPage()));
                      break;
                    case _menuValue.about:
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AboutPage()));
                  }
                },
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Transform(
                transform:
                    Matrix4.translationValues(_translateButton.value, 0, 0),
                child: Container(
                  child: FloatingActionButton(
                    heroTag: 'btn3',
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new StandardEditorPage()));
                    },
                    tooltip: 'Inbox',
                    child: Icon(Icons.add),
                  ),
                ),
              ),
//              SizedBox(
//                height: 10,
//              ),
//              Transform(
//                transform:
//                    Matrix4.translationValues(_translateButton.value, 0, 0),
//                child: Container(
//                  child: FloatingActionButton(
//                    heroTag: 'btn2',
//                    onPressed: null,
//                    tooltip: 'Inbox',
//                    child: Icon(Icons.inbox),
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 10,
//              ),
//              Transform(
//                transform:
//                    Matrix4.translationValues(_translateButton.value, 0, 0),
//                child: Container(
//                  child: FloatingActionButton(
//                    heroTag: 'btn1',
//                    onPressed: null,
//                    tooltip: 'Inbox',
//                    child: Icon(Icons.inbox),
//                  ),
//                ),
//              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: 'btn0',
                onPressed: animate,
                backgroundColor: _animateColor.value,
                child: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow,
                  progress: _animateIcon,
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              String temp = model.notes[index].text;
              if (temp != null) if (temp.length > 15)
                temp = temp.substring(0, 15);
              return Dismissible(
                key: new Key(model.notes[index].id.toString() +
                    Random().nextInt(1000).toString()),
                child: Card(
                  child: RaisedButton(
                    color: Color(model.notes[index].color??Colors.blue),
                    onPressed: () {
                      model.setNoteTemp(model.notes[index]);
                      model.setId(index);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new EditorWithKeyPage()));
                    },
                    child: ListTile(
                      title: Text(model.notes[index].title),
                      subtitle: Text(temp),
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  _noteProvider.delete(model.notes[index].id);
                  model.deleteNote(index);
                },
              );
            },
            itemCount: model.notes == null ? 0 : model.notes.length,
          ),
        );
      },
    );
  }
}
