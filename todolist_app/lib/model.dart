import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo extends ChangeNotifier{
  List<String> _todoList = [];
  List<String> get todoList => _todoList;

  Future<void> addData(String task) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _todoList = pref.getStringList('todo') ?? [];
    _todoList.add(task);
    pref.setStringList('todo', _todoList);
    notifyListeners();
  }

  Future<void> loadData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _todoList = pref.getStringList('todo') ?? [];
    notifyListeners();
  }

  Future<void> deleteData(int index) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _todoList = pref.getStringList('todo') ?? [];
    _todoList.removeAt(index);
    pref.setStringList('todo', _todoList);
    notifyListeners();
  }

  Future<void> editData(int index, String editedTask) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _todoList = pref.getStringList('todo') ?? [];
    _todoList[index] = editedTask;
    pref.setStringList('todo', _todoList);
    notifyListeners();
  }



}