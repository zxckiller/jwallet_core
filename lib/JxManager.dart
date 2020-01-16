import 'package:flutter/material.dart';
import 'package:jwallet_core/Error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

mixin JPresistManager{

//增
  @protected
  Future<String> addOne(String key,Map<String,dynamic> value) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) => print('>>> [addOne] $key, ${prefs.get(key)}'));
    bool already = prefs.containsKey(key);
    if(already) throw JUBR_ALREADY_EXITS;
    bool success = await prefs.setString(key, json.encode(value));
    if(success) return Future<String>.value(key);
    else throw JUBR_HOST_MEMORY;
  }
//改
  @protected
  Future<String> updateOne(String key,Map<String,dynamic> value)async{
    print('>>> [updateOne] key: $key, value: ${value.toString()} ');
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    if (!await containsKey(key)) {
      throw JUBR_NEVER_EXITS;
    }
    bool success = await prefs.setString(key, json.encode(value));
    if(success) return Future<String>.value(key);
    else throw JUBR_HOST_MEMORY;
  }

//查
  @protected
  Future<Map<String,dynamic>> getOne(String key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    if(value == null)
      throw JUBR_NO_ITEM;
    return json.decode(value); 
  }

//删
  @protected
  Future<bool> deleteOne(String key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    bool state = await prefs.remove(key);
    return prefs.remove(key);
  }

  @protected
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