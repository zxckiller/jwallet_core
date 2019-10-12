import 'package:jwallet_core/Error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

mixin JPresistManager{

  Future<String> addOne(String key,Map<String,dynamic> value) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    bool success = await prefs.setString(key, json.encode(value));
    if(success) return Future<String>.value(key);
    else throw JUBR_HOST_MEMORY;
  }

  Future<Map<String,dynamic>> getOne(String key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    if(value == null)
      throw JUBR_NO_ITEM;
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

  Future<bool> containsKey(String key) async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    return Future<bool>.value(prefs.containsKey(key));
  }

}

// class JxManager<T>{
//   Map<String,T> _map = new Map<String,T>();
//   var uuid = new Uuid();
//   String addOne(T t,[String key]){
//     if(key == null)key = uuid.v4();
//     _map[key] = t;
//     return key;
//   }
  
//   T getOne(String key){
//     return _map[key];
//   }

//   void deleteOne(String key){
//     _map.remove(key);
//   }

//   Map<String,T> enumAll(){
//     return _map;
//   }
// }