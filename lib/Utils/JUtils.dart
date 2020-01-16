

import 'package:jwallet_core/Error.dart';

T firstChange<T>(T f,T t) {
  if(t == null) return f;          //没有要修改的值，保持原值
  if(f == null) return t;          //原值为null，改成新的
  if(f == "") return t;            //原值为空，改成新的
  if(f != t) throw JUBR_ERROR;     //原值有值，但与新值不一样，发生不可预知的异常，出错
  
  return f;                        //什么都没发生
}