import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnStartDialogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnStartDialogState();
}

class _OnStartDialogState extends State<OnStartDialogPage> with SingleTickerProviderStateMixin  {
  double _elevation=100.0;
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController=AnimationController(vsync: this,duration: Duration(seconds: 1));
    _animation=new Tween(begin: 200.0,end: 5.0).animate(_animationController)..addListener(()=>setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Text(''),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_left,size: 50,),
            Text('分组',style: TextStyle(fontSize: 30),),
          ],
        ),
        actions: <Widget>[
          Text(
            '菜单',
            style: TextStyle(fontSize: 30),
          ),
          Icon(Icons.keyboard_arrow_right,size: 50,),
          SizedBox(
            width: 60,
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('添加备忘',style: TextStyle(fontSize: 30,color: Colors.white),),
          Icon(Icons.keyboard_arrow_right,size: 50, color: Colors.white,),
          SizedBox(width: 50,),

        ],
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            _animationController.forward();
            forwardMe()async{
              await Future.delayed(Duration(seconds: 1),);
              Navigator.pop(context);
            }
            _changeShared()async{
              SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
              sharedPreferences.setBool('startAtOne', false);
            }
            _changeShared();
            forwardMe();
          },
          child: Text('开始使用',style: TextStyle(fontSize: 30),),
          height: 300,
          minWidth: 300,
          color: Color(0xffffffff),
          elevation: _animation.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
        ),
      ),
    );
  }
}
