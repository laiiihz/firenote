import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firenote/Database/MainDatabase.dart';

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
  List<FireNote> _notes=[];
  get notes=>_notes;
  setNotes(List<FireNote> getNotes){
    _notes=getNotes;
    notifyListeners();
  }
  addNote(FireNote fireNote){
    if(_notes==null)_notes.add(fireNote);
    else _notes.insert(0, fireNote);
    notifyListeners();
  }

  int _idMe=0;
  get idMe=>_idMe;
  setId(int id){
    _idMe=id;
    notifyListeners();
  }
  updateNote(FireNote note){
    notes[_idMe]=note;
    notifyListeners();
  }

  deleteNote(index){
    _notes.removeAt(index);
    notifyListeners();
  }

  FireNote _tempNote=FireNote();
  get tempNote=>_tempNote;
  setNoteTemp(FireNote fireNote){
    _tempNote=fireNote;
    print('realID:'+tempNote.id.toString());
    notifyListeners();
  }
}