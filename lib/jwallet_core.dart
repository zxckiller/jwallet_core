library jwallet_core;
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void init(){
  getIt.registerSingleton<Calculator>(Calculator());
}


class Jwallet{
  static Calculator getCalculator(){
  return getIt<Calculator>();
  }
}



/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value){
    return value + 1;
  }
}
