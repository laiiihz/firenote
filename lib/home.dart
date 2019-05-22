import 'package:flutter/material.dart';
import 'menu/About.dart';
import 'menu/Settings.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

enum _menuValue { about, settings }

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _floatingIsOpened = false;
  AnimationController _animationController;
  Animation<double> _animateIcon;
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
    // TODO: implement build

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
            itemBuilder: (BuildContext context) => <PopupMenuEntry<_menuValue>>[
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
      floatingActionButton: FloatingActionButton(
        onPressed: animate,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
        
      ),
    );
  }
}
