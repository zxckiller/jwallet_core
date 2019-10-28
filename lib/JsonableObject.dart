abstract class JsonableObject{
  Map<String, dynamic> toJson();
  Map<String, dynamic> toJsonKey();
  //这个函数放在这是提醒开发人员，新建一个jsonable对象的时候是否需要是持久化的数据
  //https://github.com/dart-lang/sdk/issues/28305 dart 不会await void，只能加Future<bool>
  Future<bool> updateSelf();
}