import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/Database/MainDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';
class StandardEditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StandardEditorState();
}

class _StandardEditorState extends State<StandardEditorPage> {
  Color _myColor = Color(0x44ffffff);
  var _titleController=TextEditingController();
  var _textController=TextEditingController();
  ///***DATABASE***/
  NoteProvider _noteProvider=NoteProvider();
  ///***DATABASE***/



  @override
  Widget build(BuildContext context) {
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
                                  _buildButton(Colors.cyan),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.amberAccent),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.indigo),
                                  SizedBox(width: 10,),
                                  _buildButton(Colors.teal),
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
            onPressed: () async{
              print(_titleController.text);
              var databasePath=await getDatabasesPath();
              var me=_noteProvider.open(Path.join(databasePath,'app.db'));
              List<FireNote> notes=[];
              FireNote fireNote=FireNote();
              insertOp()async{
                fireNote.text=_textController.text;
                fireNote.title=_titleController.text;
                fireNote.color=_myColor.value;
                await _noteProvider.insert(fireNote);
              }
              me.then((value){
                try{
                  insertOp();
                }catch(e){
                  print('fail');
                  print(e);
                }
              });
              AppModel model=ScopedModel.of(context);
              model.addNote(fireNote);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: TextField(
              controller: _titleController,
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
              controller: _textController,
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
