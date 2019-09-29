import 'package:uuid/uuid.dart';

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