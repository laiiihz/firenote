import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/Database/MainDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firenote/model/appModel.dart';

class StandardEditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StandardEditorState();
}

class _StandardEditorState extends State<StandardEditorPage> {
  Color _myColor = Color(0x44ffffff);
  var _titleController = TextEditingController();
  var _textController = TextEditingController();
  DateTime _dateTime;
  TimeOfDay _dateOfDay;
  int _timeMillsec = DateTime.now().millisecondsSinceEpoch;
  DateTime _nowTime = DateTime.now();
  Timer countdownTimer;
  var _value = 0;
  List<DropdownMenuItem<int>> genWidget=[];

  ///***DATABASE***/
  NoteProvider _noteProvider = NoteProvider();

  ///***DATABASE***/

  Future<Null> _showDatePicker(BuildContext context) async {
    final DateTime _picker = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch -
              (TimeOfDay.now().minute + TimeOfDay.now().hour * 60) * 60 * 1000),
      firstDate: DateTime(2019, 1, 1),
      lastDate: DateTime(2099),
    );

    if (_picker != null) {
      setState(() {
        _dateTime = _picker;
      });
      print(_dateTime);
    }
  }

  Future<Null> _showTimePicker(BuildContext context) async {
    final TimeOfDay _timePicker =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (_timePicker != null) {
      setState(() {
        _dateOfDay = _timePicker;
        _timeMillsec = _dateTime.millisecondsSinceEpoch +
            (_dateOfDay.hour * 60 + _dateOfDay.minute) * 60 * 1000;
      });
      print(_dateOfDay);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        _nowTime = DateTime.now();
      });
    });
    AppModel model=ScopedModel.of(context);
    setState(() {
      _value=model.pageNow;
    });
    List<String> tag=model.tags;
    for (var i = 0; i < tag.length; ++i) {
      genWidget.add(
        DropdownMenuItem(
          child: Text(tag[i]),
          value: i,
        ),
      );
    }
    countdownTimer.tick;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    countdownTimer.cancel();
  }

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
            padding: EdgeInsets.all(5),
            child: IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  _showTimePicker(context);
                  _showDatePicker(context);
                }),
          ),
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildButton(Colors.grey),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildButton(Colors.blueGrey),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildButton(Colors.greenAccent),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  _buildButton(Colors.cyanAccent),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildButton(Colors.amberAccent),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildButton(Colors.indigoAccent),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildButton(Colors.tealAccent),
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
            onPressed: () async {
              print(_titleController.text);
              var databasePath = await getDatabasesPath();
              var me =
                  _noteProvider.open(Path.join(databasePath, 'app-0-1.db'));
              List<FireNote> notes = [];
              FireNote fireNote = FireNote();
              insertOp() async {
                fireNote.text = _textController.text;
                fireNote.title = _titleController.text;
                fireNote.color = _myColor.value;
                fireNote.timeNow = DateTime.now().millisecondsSinceEpoch;
                fireNote.timeSet = _timeMillsec;
                fireNote.tag=_value;
                print('dateTime set');
                print(fireNote.timeSet);
                await _noteProvider.insert(fireNote);
              }

              me.then((value) {
                try {
                  insertOp();
                } catch (e) {
                  print('fail');
                  print(e);
                }
              });
              AppModel model = ScopedModel.of(context);
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
                suffixIcon: DropdownButton(
                  items: genWidget,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  value: _value,
                ),
              ),
              cursorColor: Colors.red,
              cursorWidth: 5,
              textInputAction: TextInputAction.next,
              maxLength: 15,
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
          Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: ListTile(
                leading: Text('创建时间:' + _nowTime.toString().substring(0, 19)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: ListTile(
                leading: Text('提醒时间:' +
                    DateTime.fromMillisecondsSinceEpoch(_timeMillsec ?? 0)
                        .toString()
                        .substring(0, 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
