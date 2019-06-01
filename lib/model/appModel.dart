import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:firenote/Database/MainDatabase.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AppModel extends Model {
  ThemeData _appTheme = ThemeData.light();
  get appTheme => _appTheme;
  bool _isDarkModeOn = false;
  get isDarkModeOn => _isDarkModeOn;

  setDarkMode(bool value) {
    _isDarkModeOn = value;
    if (_isDarkModeOn) {
      _appTheme = ThemeData.dark().copyWith(
        platform: _iphoneStyleOn ? TargetPlatform.iOS : TargetPlatform.android,
      );
    } else {
      _appTheme = ThemeData.light().copyWith(
        platform: _iphoneStyleOn ? TargetPlatform.iOS : TargetPlatform.android,
      );
    }

    notifyListeners();
  }

  Color _primaryColor = Colors.blue;
  get primaryColor => _primaryColor;
  String _colorName = '蓝色';
  get colorName => _colorName;
  setPrimaryColor(Color color, String colorName) {
    _appTheme = _appTheme.copyWith(
      primaryColor: color,
    );
    _primaryColor = color;
    _colorName = colorName;
    notifyListeners();
  }

  bool _iphoneStyleOn = false;
  get iphoneStyleOn => _iphoneStyleOn;
  setIPhoneStyleOn(bool value) {
    _appTheme = _appTheme.copyWith(
      platform: value ? TargetPlatform.iOS : TargetPlatform.android,
    );
    _iphoneStyleOn = value;
    notifyListeners();
  }

  List<FireNote> _notes = [];
  get notes => _notes;
  setNotes(List<FireNote> getNotes) {
    _notes = getNotes;
    notifyListeners();
  }

  addNote(FireNote fireNote) {
    if (_notes == null)
      _notes.add(fireNote);
    else
      _notes.insert(0, fireNote);
    notifyListeners();
  }

  int _idMe = 0;
  get idMe => _idMe;
  setId(int id) {
    _idMe = id;
    notifyListeners();
  }

  updateNote(FireNote note) {
    notes[_idMe] = note;
    notifyListeners();
  }

  deleteNote(index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  FireNote _tempNote = FireNote();
  get tempNote => _tempNote;
  setNoteTemp(FireNote fireNote) {
    _tempNote = fireNote;
    print('realID:' + tempNote.id.toString());
    notifyListeners();
  }

  bool _statusBarTransparent=false;
  get statusBarTransparent=>_statusBarTransparent;

  setStatusBarTransparent(bool transparent){
    _statusBarTransparent=transparent;
    SystemUiOverlayStyle systemUiOverlayStyle=SystemUiOverlayStyle(statusBarColor: transparent?Colors.transparent:Color(0x33000000));
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    notifyListeners();
  }

  int _page=0;
  get page=>_page;
  setPage(int pageMe){
    _page=pageMe;
    notifyListeners();
  }

  String _userName='fireNote';
  get userName=>_userName;
  setUserName(String name){
    _userName=name;
    notifyListeners();
  }

  int _tagCount=0;
  get tagCount=>_tagCount;
  setTagCount(int num){
    _tagCount=num;
    print('tag number'+_tagCount.toString());
    notifyListeners();
  }

  List<String> _tags=[];
  get tags=>_tags;
  setTags(List<String> tagsMe){
    _tags.addAll(tagsMe);
    if(tagsMe!=null){
      _tagCount=tagsMe.length;
    }
    notifyListeners();
  }

  addTags(String singleTag){
    _tags.add(singleTag);
    _tagCount++;
    addTagShared()async{
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      sharedPreferences.setStringList('tags',_tags);
    }
    addTagShared();
    notifyListeners();
  }

  clearTags(){
    _tags=['all'];
    _tagCount=1;
    clearTagShared()async{
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      sharedPreferences.setStringList('tags',_tags);
    }
    clearTagShared();
    notifyListeners();
  }
  deleteTag(int index){
    _tags.removeAt(index);
    _tagCount--;
    deleteTagShared()async{
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      sharedPreferences.setStringList('tags',_tags);
    }
    deleteTagShared();
    notifyListeners();
  }


  List<FireNote> noteWithTag(int index){
    List<FireNote > result=[];
    for (var i = 0; i < _notes.length; ++i) {
      if(index==_notes[i].tag){
        result.add(_notes[i]);
      }
    }
    return result;
  }

  deleteAllNoteAtTag(int index){
    for (var i = _notes.length-1; i>=0; i--) {
      if(_notes[i].tag==index){
        _notes.removeAt(i);
      }
      notifyListeners();
    }
  }
}
