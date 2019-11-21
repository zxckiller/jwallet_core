import 'package:http/http.dart' as http;
import 'dart:convert';

mixin JHttpJubiter{

  //傻逼dart不支持泛型实例化，否则这个函数返回应该是一个实例化好的泛型类型，上层直接使用。现在只能返回Json让上层自己实例化成各种Model，多写N多代码
  Future<Map<String,dynamic>> httpPost(String url,Map<String,String> parmas) async{
    String uriParams = "";
    parmas.forEach((k,v){
        if(v != null){
          uriParams += k;
          uriParams += "=";
          uriParams += v;
          uriParams += "&";
        }
    });
    if(parmas.length != 0) uriParams = uriParams.substring(0,uriParams.length-1);
    
    var header = Map<String,String>();
    header['Content-Type'] = "application/x-www-form-urlencoded";
    var response = await http.post(url,headers:header,body:uriParams);
    var resBody = json.decode(response.body);
    if(resBody["statusCode"] != 0) throw resBody["statusCode"];
    return Future<Map<String,dynamic>>.value(resBody);
  }

  Future<Map<String,dynamic>> httpGet(String url,[Map<String,String> parmas]) async{
    if(parmas != null && parmas.length != 0){
      url += "?";
      parmas.forEach((k,v){
          if(v != null){
            url += k;
            url += "=";
            url += v;
            url += "&";
          }
      });
      url = url.substring(0,url.length-1);
    } 

    var header = Map<String,String>();
    header['Content-Type'] = "application/x-www-form-urlencoded";
    var response = await http.get(url,headers:header);
    var resBody = json.decode(response.body);
    if(response.statusCode < 200 || response.statusCode >= 300) throw response.statusCode;
    return Future<Map<String,dynamic>>.value(resBody);
  }
  
}