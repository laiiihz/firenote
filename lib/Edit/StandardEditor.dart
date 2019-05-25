import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class StandardEditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StandardEditorState();
}

class _StandardEditorState extends State<StandardEditorPage> {
  Color _myColor = Colors.white;
  Widget _buildButton(Color color) {
    return RawMaterialButton(
      onPressed: () {
        setState(() {
          _myColor = color;
          Navigator.of(context).pop();
        });
      },
      shape: CircleBorder(),
      fillColor: color,
      constraints: BoxConstraints(minWidth: 60, minHeight: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('新建备忘'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return new SimpleDialog(
                      title: Text('选择颜色'),
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  _buildButton(Colors.pinkAccent),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.grey),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.blueGrey),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.green),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  _buildButton(Colors.pink),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.pink),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.pink),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.pink),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: _myColor,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                labelText: '标题',
                hintText: '输入你的标题',
                border: OutlineInputBorder(),
              ),
              cursorColor: Colors.red,
              cursorWidth: 5,
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 100,
              minLines: 20,
            ),
          ),
        ],
      ),
    );
  }
}
