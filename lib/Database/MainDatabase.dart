

import 'package:sqflite/sqflite.dart';

final String tableNote = 'note';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnText = 'text';
final String columnColor = 'color';
final String columnTimeCreate='timecreate';
final String columnTimeSet='timeset';
final String columnTag='tag';

class FireNote {
  int id;
  String title;
  String text;
  int color;
  int timeNow;
  int timeSet;
  int tag;
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnText: text,
      columnColor: color,
      columnTimeCreate:timeNow,
      columnTimeSet:timeSet,
      columnTag:tag
    };
    if (id != null) map[columnId] = id;
    return map;
  }
  FireNote();
  FireNote.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    text = map[columnText];
    color = map[columnColor];
    timeNow=map[columnTimeCreate];
    timeSet=map[columnTimeSet];
    tag=map[columnTag];
  }
}

class NoteProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int ver) async {
      await db.execute('''
      create table $tableNote(
      $columnId integer primary key autoincrement,
      $columnTitle text not null,
      $columnText text,
      $columnColor integer not null,
      $columnTimeCreate datetime,
      $columnTimeSet datetime,
      $columnTag integer
      )
      ''');
    });
    print(db);
  }

  Future<FireNote> insert(FireNote fireNote) async {
    fireNote.id = await db.insert(tableNote, fireNote.toMap());
    return fireNote;
  }

  Future<FireNote> getFireNote(int id) async {
    List<Map> maps = await db.query(tableNote,
        columns: [columnId, columnTitle, columnText, columnColor,columnTimeCreate,columnTimeSet,columnTag],
        where: '$columnId=?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return FireNote.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableNote, where: '$columnId=?', whereArgs: [id]);
  }

  Future<int> update(FireNote fireNote) async {
    return await db.update(
      tableNote,
      fireNote.toMap(),
      where: '$columnId=?',
      whereArgs: [fireNote.id],
    );
  }

  Future<List<FireNote>> getAllNote() async {
    List<Map> maps = await db.query(
      tableNote,
      columns: [columnId,columnTitle,columnText,columnColor,columnTimeCreate,columnTimeSet,columnTag],
    );

    if(maps.length==0||maps.isEmpty||maps==null)return null;
    List<FireNote> notes=[];
    for(int i=0;i<maps.length;i++){
      notes.add(FireNote.fromMap(maps[i]));
    }

    return notes.reversed.toList();
  }

  Future deleteAllData()async{
    return await db.delete(tableNote,where: null,whereArgs: null);
  }

  Future deleteAtAllTag(int index)async{
    return await db.delete(tableNote,where: '$columnTag=?',whereArgs: [index]);
  }

  Future close() async => db.close();

}
