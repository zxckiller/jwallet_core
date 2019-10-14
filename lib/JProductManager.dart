import './JxManager.dart';
import './JProduct/JProductBase.dart';
import './JProduct/JProductHD.dart';
import './JProduct/JProductBlade.dart';
import './JProduct/JProductImport.dart';
import './JProduct/JProductFactory.dart';

const productDefault = "prodctDefault";
const productBlade   = "productBlade";
const productImport  = "productImport";

class JProductManager with JPresistManager{

  Future<String> newProductHD(String mnmonic,String passpahse,String password)async{
    String name = productDefault;
    JProductHD p = JProductFactory.newProducetHD(mnmonic, passpahse,password, name);
    return addOne(name, p.toJson());
  }

  Future<String> newProductBlade(String deviceSN) async{
    String name = productBlade;
    JProductBlade p = JProductFactory.newProductBlade(deviceSN, name);
    return addOne(name,p.toJson());
  }

  Future<String> newProductImport() async{
    String name = productImport;
    JProductImport p = JProductFactory.newProductImport(name);
    return addOne(name,p.toJson());
  }

  //获取某一个product
  Future<T> getProduct<T>(String key) async{
    var jsonObj = await getOne(key);
    JProductBase p = JProductFactory.fromJson(jsonObj);
    return Future<T>.value(p as T); 
  }


  // Future<JProductBase> getProduct(String key) async{
  //   var jsonObj = await getOne(key);
  //   JWalletBase wallet = JWalletFactory.fromJson(jsonObj);
  //   return Future<JWalletBase>.value(wallet); 
  // }

}