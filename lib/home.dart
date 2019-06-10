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
import 'package:shared_preferences/shared_preferences.dart';
import 'OnStart/OnStartDialog.dart';
import 'generated/i18n.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

enum _menuValue { about, settings }

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  ///*** DATABASE***/
  NoteProvider _noteProvider = NoteProvider();

  /// *DATABASE***/

  final _userNameController = TextEditingController();
  final _groupTagController = TextEditingController();
  bool _floatingIsOpened = false;
  AnimationController _animationController;
  Animation<double> _animateIcon;
  Animation<Color> _animateColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  bool _drawerDeleteState = false;
  List<FireNote> tempNotes = [];
  final _pageController = PageController(initialPage: 0);

  List<Widget> widgetNotes = [];
  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return OnStartDialogPage();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppModel model = ScopedModel.of(context);
    if (model.startAtOne ?? true) _showDialog();
    getPath() async {
      var databasePath = await getDatabasesPath();
      var me = _noteProvider.open(Path.join(databasePath, 'app-0-1.db'));
      List<FireNote> tempNotes = [];
      me.then((value) async {
        tempNotes = await _noteProvider.getAllNote();
      }).then((n) {
        FireNote tempNote = FireNote();
        tempNote.color = 0x33ffffff;
        tempNote.text = S.of(context).new_text;
        tempNote.id = 9999999;
        tempNote.title = S.of(context).welcome_and_use;
        tempNote.tag = 0;
        tempNote.timeNow = DateTime.now().millisecondsSinceEpoch;
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
            child: ListView.builder(
              itemCount: model.tagCount + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return DrawerHeader(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(30),
                              child: Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.person),
                                  backgroundColor: model.primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: FlatButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (value) {
                                          return Dialog(
                                            shape: null,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              color: Colors.transparent,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      '修改用户名',
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _userNameController,
                                                    decoration: InputDecoration(
                                                      labelText: '用户名',
                                                      filled: true,
                                                    ),
                                                    maxLength: 10,
                                                  ),
                                                  ButtonBar(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('取消'),
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () {
                                                          model.setUserName(
                                                              _userNameController
                                                                  .text);

                                                          setUserShared() async {
                                                            SharedPreferences
                                                                sh =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            sh.setString(
                                                                'userName',
                                                                _userNameController
                                                                        .text ??
                                                                    'fireNote');
                                                          }

                                                          setUserShared();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('修改'),
                                                        color:
                                                            model.primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: 120,
                                    child: Wrap(
                                      children: <Widget>[
                                        Text(
                                          model.userName,
                                          style: TextStyle(fontSize: 25),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                if (index == 1) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _drawerDeleteState = !_drawerDeleteState;
                              });
                            },
                            icon: _drawerDeleteState
                                ? Icon(Icons.arrow_back)
                                : Icon(Icons.delete_sweep),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            model.setPage(0);
                            Navigator.pop(context);
                            _pageController.animateToPage(0,
                                duration: Duration(seconds: 2),
                                curve: Curves.ease);
                          },
                          height: model.page == 0 ? 70 : 30,
                          shape: null,
                          color: model.page == 0 ? model.primaryColor : null,
                          child: ListTile(
                            leading: Icon(Icons.home),
                            title: Text(
                              '所有',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  int tempIndex = index - 1;
                  return Container(
                    child: MaterialButton(
                      onPressed: () {
                        model.setPage(tempIndex);
                        Navigator.pop(context);
                        _pageController.animateToPage(tempIndex,
                            duration: Duration(seconds: 2), curve: Curves.ease);
                      },
                      height: model.page == tempIndex ? 70 : 30,
                      color:
                          model.page == tempIndex ? model.primaryColor : null,
                      child: ListTile(
                        leading: Icon(Icons.bookmark_border),
                        title: Text(model.tags[tempIndex]),
                        trailing: Offstage(
                          offstage: !_drawerDeleteState,
                          child: IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                model.deleteTag(tempIndex);
                                _noteProvider.deleteAtAllTag(tempIndex);
                                model.deleteAllNoteAtTag(tempIndex);
                              }),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          appBar: AppBar(
            title: Hero(
              tag: 'title',
              child: Material(
                color: Colors.transparent,
                child: Text(S.of(context).appName,style: TextStyle(fontSize: 30,color: Colors.white),),
              ),
            ),
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
                      model.changePage(_pageController.page);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new StandardEditorPage()));
                    },
                    tooltip: '新建备忘',
                    child: Icon(Icons.add),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Transform(
                transform:
                    Matrix4.translationValues(_translateButton.value, 0, 0),
                child: Container(
                  child: FloatingActionButton(
                    heroTag: 'btn2',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: null,
                              title: Text('添加分组'),
                              content: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: '分组名称',
                                        prefixIcon: Icon(Icons.group_add),
                                        filled: true,
                                      ),
                                      maxLength: 3,
                                      controller: _groupTagController,
                                    ),
                                    ButtonBar(
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('取消'),
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            var text = _groupTagController.text;
                                            model.addTags(text);
                                            _groupTagController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text('添加'),
                                          color: model.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    tooltip: '添加分组',
                    child: Icon(Icons.group_add),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Transform(
                transform:
                    Matrix4.translationValues(_translateButton.value, 0, 0),
                child: Container(
                  child: FloatingActionButton(
                    heroTag: 'btn1',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('清除所有备忘？'),
                              content: Text('将清除所有备忘。'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('取消'),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    _noteProvider.deleteAllData();
                                    model.setNotes([]);
                                    model.clearTags();
                                    Navigator.pop(context);
                                  },
                                  child: Text('清除'),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                ),
                              ],
                            );
                          });
                    },
                    tooltip: '清除所有备忘',
                    child: Icon(Icons.clear_all),
                  ),
                ),
              ),
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
                tooltip: '^_^',
              ),
            ],
          ),
          body: PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    String temp = model.notes[index].text;
                    String tempDate = DateTime.fromMillisecondsSinceEpoch(
                            model.notes[index].timeNow)
                        .toString();
                    String tempDatePartA = tempDate.substring(0, 10);
                    String tempDatePartB = tempDate.substring(11, 19);

                    String tempDateSet = DateTime.fromMillisecondsSinceEpoch(
                            model.notes[index].timeSet ?? 0)
                        .toString();
                    String tempDateSetPartA = tempDateSet.substring(0, 10);
                    String tempDateSetPartB = tempDateSet.substring(11, 16);
                    if (temp != null) if (temp.length > 15)
                      temp = temp.substring(0, 15);
                    return Dismissible(
                      key: new Key(model.notes[index].id.toString() +
                          Random().nextInt(1000).toString()),
                      child: MaterialButton(
                        color: Color(model.notes[index].color ?? Colors.blue),
                        onPressed: () {
                          model.setNoteTemp(model.notes[index]);
                          model.setId(index);
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new EditorWithKeyPage()));
                        },
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: model.notes[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w100, fontSize: 20),
                              ),
                              TextSpan(
                                  text: model.tags[model.notes[index].tag],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  )),
                            ]),
                          ),
                          subtitle: Text(temp),
                          trailing:
                              Text(tempDateSetPartA + '\n' + tempDateSetPartB),
                        ),
                      ),
                      background: Container(
                        color: Colors.red,
                        child: ListTile(
                          leading: Icon(Icons.delete),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.cyan,
                        child: ListTile(
                          trailing: Text(
                            tempDatePartA + '\n' + tempDatePartB,
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          _noteProvider.delete(model.notes[index].id);
                          model.deleteNote(index);
                          final snackBar = SnackBar(
                            content: Icon(Icons.delete_forever),
                            duration: Duration(seconds: 1),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                        if (direction == DismissDirection.endToStart) {
                          final snackBar = SnackBar(
                            content: Icon(Icons.tag_faces),
                            duration: Duration(seconds: 1),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);

                          setState(() {
                            widgetNotes = widgetNotes;
                          });
                        }
                      },
                    );
                  },
                  itemCount: model.notes == null ? 0 : model.notes.length,
                );
              } else {
                tempNotes = model.noteWithTag(index);
                if (tempNotes.length == 0)
                  return Center(
                    child: Icon(
                      Icons.tag_faces,
                      size: 100,
                      color: model.primaryColor,
                    ),
                  );
                return ListView.builder(
                  itemBuilder: (BuildContext context, int indexList) {
                    return Dismissible(
                      key: new Key(tempNotes[indexList].id.toString() +
                          Random().nextInt(1000).toString()),
                      child: MaterialButton(
                        onPressed: () {},
                        color: Color(tempNotes[indexList].color),
                        child: ListTile(
                          title: Text(tempNotes[indexList].title),
                          subtitle: Text(tempNotes[indexList].text),
                          trailing: Text(DateTime.fromMillisecondsSinceEpoch(
                                  tempNotes[indexList].timeSet)
                              .toString()),
                        ),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          _noteProvider.delete(tempNotes[indexList].id);
                          model.deleteNote(indexList);
                          final snackBar = SnackBar(
                            content: Icon(Icons.delete_forever),
                            duration: Duration(seconds: 1),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                        if (direction == DismissDirection.endToStart) {
                          final snackBar = SnackBar(
                            content: Icon(Icons.tag_faces),
                            duration: Duration(seconds: 1),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                          setState(() {
                            tempNotes = tempNotes;
                          });
                        }
                      },
                      background: Container(
                        child: ListTile(
                          leading: Icon(Icons.delete_forever),
                        ),
                        color: Colors.red,
                      ),
                      secondaryBackground: Container(
                        child: ListTile(
                          trailing: Text(DateTime.fromMillisecondsSinceEpoch(
                                  tempNotes[indexList].timeNow)
                              .toString()),
                        ),
                        color: Colors.cyan,
                      ),
                    );
                  },
                  itemCount: tempNotes.length,
                );
              }
            },
            itemCount: model.tagCount,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
          ),
        );
      },
    );
  }
}
