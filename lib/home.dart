import 'package:flutter/material.dart';
import 'menu/About.dart';
import 'menu/Settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/appModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

enum _menuValue { about, settings }

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _floatingIsOpened = false;
  AnimationController _animationController;
  Animation<double> _animateIcon;
  Animation<Color> _animateColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          });

    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animateColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          1.00,
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
        0.75,
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
                Matrix4.translationValues( _translateButton.value , 0,0),
                child: Container(
                  child: FloatingActionButton(
                    heroTag: 'btn3',
                    onPressed: null,
                    tooltip: 'Inbox',
                    child: Icon(Icons.inbox),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Transform(
                transform:
                Matrix4.translationValues( _translateButton.value , 0,0),
                child: Container(
                  child: FloatingActionButton(
                    heroTag: 'btn2',
                    onPressed: null,
                    tooltip: 'Inbox',
                    child: Icon(Icons.inbox),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Transform(
                transform:
                  Matrix4.translationValues( _translateButton.value , 0,0),
                  child: Container(
                    child: FloatingActionButton(
                      heroTag: 'btn1',
                      onPressed: null,
                      tooltip: 'Inbox',
                      child: Icon(Icons.inbox),
                    ),
                  ),
              ),
              SizedBox(height: 10,),
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
        );
      },
    );
  }
}
