import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

mixin JPresistManager{

  final uuid = new Uuid();

  Future<String> addOne(String key,Map<String,dynamic> value,[bool addUuid = true]) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String _key = "";
    if(addUuid){
      try {
        var _j = json.decode(key);
        _j["uuid"] = uuid.v4();
        _key = json.encode(_j);
      } catch (e) {
        _key = key;
      }
    }
    prefs.setString(_key, json.encode(value));
    return _key;
  }

  Future<Map<String,dynamic>> getOne(String key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return json.decode(value); 
  }

  Future<bool> deleteOne(String key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<Set<String>> enumAll() async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    return Future<Set<String>>.value(prefs.getKeys()); 
  }

}

class JxManager<T>{
  Map<String,T> _map = new Map<String,T>();
  var uuid = new Uuid();
  String addOne(T t,[String key]){
    if(key == null)key = uuid.v4();
    _map[key] = t;
    return key;
  }
  
  T getOne(String key){
    return _map[key];
  }

  void deleteOne(String key){
    _map.remove(key);
  }

  Map<String,T> enumAll(){
    return _map;
  }
}