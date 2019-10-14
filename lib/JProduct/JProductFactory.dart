import './JProductBase.dart';
import './JProductHD.dart';
import './JProductBlade.dart';
import './JProductImport.dart';

//几种Product创建的参数不同都不相同，需要分开创建
class JProductFactory{

  static JProductHD newProducetHD(String mnmonic,String passpahse,String password,String name){
    return new JProductHD(mnmonic,passpahse,password,name);
  }

  static JProductBlade newProductBlade(String deviceSN,String name){
    return new JProductBlade(deviceSN,name);
  }

  static JProductImport newProductImport(String name){
    return new JProductImport(name);
  }


  static JProductBase fromJson(Map<String, dynamic> json){
    ProductType pType = ProductType.values[json["pType"]];
    JProductBase product;
    switch (pType) {
      case ProductType.HD:
        product = new JProductHD.fromJson(json);
        break;
      case ProductType.JubiterBlade:
        product = new JProductBlade.fromJson(json);
        break;
      case ProductType.Import:
        product = new JProductImport.fromJson(json);
        break;
      default:
    }
    return product;
  }

}