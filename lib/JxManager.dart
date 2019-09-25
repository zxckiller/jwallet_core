import 'package:uuid/uuid.dart';

class JxManager<T>{
  Map<String,T> _map = new Map<String,T>();
  String addOne(T t){
    var uuid = new Uuid();
    _map[uuid.v4()] = t;
    return uuid.v4();
  }
  T getOne(String key){
    return _map[key];
  }

  String insertOne(String key, T t){
    _map[key] = t;
    return key;
  }
  
  void deleteOne(String key){
    _map.remove(key);
  }

  Map<String,T> enumAll(){
    return _map;
  }
}