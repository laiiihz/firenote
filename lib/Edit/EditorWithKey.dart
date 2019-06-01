import 'package:flutter/material.dart';
import 'package:firenote/Database/MainDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'package:scoped_model/scoped_model.dart';
import 'package:firenote/model/appModel.dart';
import 'dart:async';

class EditorWithKeyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditorWithKeyState();
}

class _EditorWithKeyState extends State<EditorWithKeyPage> {
  Color _myColor = Color(0x44ffffff);
  var _titleController = TextEditingController();
  var _textController = TextEditingController();

  ///***DATABASE***/
  NoteProvider _noteProvider = NoteProvider();

  ///***DATABASE***/

  DateTime _dateTime;
  TimeOfDay _dateOfDay;
  int _timeMillsec = DateTime.now().millisecondsSinceEpoch;
  DateTime _nowTime = DateTime.now();
  Timer countdownTimer;
  var _value = 0;
  List<DropdownMenuItem<int>> genWidget=[];

  Future<Null> _showDatePicker(BuildContext context) async {
    AppModel appModel = ScopedModel.of(context);
    final DateTime _picker = await showDatePicker(
      context: context,
      initialDate:
          DateTime.fromMillisecondsSinceEpoch(appModel.tempNote.timeSet),
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
    AppModel appModel = ScopedModel.of(context);
    final TimeOfDay _timePicker = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(appModel.tempNote.timeSet)));
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
    AppModel model = ScopedModel.of(context);
    List<String> tag=model.tags;
    for (var i = 0; i < tag.length; ++i) {
      genWidget.add(
        DropdownMenuItem(
          child: Text(tag[i]),
          value: i,
        ),
      );
    }
    setState(() {
      _value=model.tempNote.tag;
    });
    setState(() {
      _myColor = Color(model.tempNote.color);
    });
    _titleController.text = model.tempNote.title;
    _textController.text = model.tempNote.text;

    countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        _nowTime = DateTime.now();
      });
    });
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

    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('更新备忘'),
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
                  FireNote fireNote = FireNote();
                  insertOp() async {
                    fireNote.text = _textController.text;
                    fireNote.title = _titleController.text;
                    fireNote.color = _myColor.value;
                    fireNote.id = model.tempNote.id;
                    fireNote.timeNow = DateTime.now().millisecondsSinceEpoch;
                    fireNote.timeSet = _timeMillsec;
                    fireNote.tag=_value;
                    print('note id:' + fireNote.id.toString());
                    await _noteProvider.update(fireNote);
                  }

                  me.then((value) {
                    try {
                      insertOp();
                    } catch (e) {
                      print('fail');
                      print(e);
                    }
                  });
                  model.updateNote(fireNote);
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
                    leading: Text('创建时间:' +
                        DateTime.fromMillisecondsSinceEpoch(
                                model.tempNote.timeNow)
                            .toString()
                            .substring(0, 19)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                  child: ListTile(
                    leading:
                        Text('更新时间:' + _nowTime.toString().substring(0, 19)),
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
      },
    );
  }
}
