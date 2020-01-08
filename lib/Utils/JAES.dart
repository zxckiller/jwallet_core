
import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;
import 'package:encrypt/encrypt.dart';


 Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;  //UUID for iOS
      }
    } catch (e){
      print('Failed to get platform version');
    }

//if (!mounted) return;
return [deviceName, deviceVersion, identifier];
}

//可能需要在原文前面补一个magic，来保证解密出来的数据是对的
mixin JAES{
  Future<String> encryptAES(String plainText) async{
    
    if(plainText == "") return "";
    var deviceInfo = await getDeviceDetails();
    var key = Key.fromUtf8(deviceInfo[2]); //identifier
    var encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);

    var encrypted = encrypter.encrypt(plainText,iv: iv);
    return encrypted.base64;
  }



  Future<String> decryptAES(String encryptedBase64) async{
    if(encryptedBase64 == "") return "";
    var deviceInfo = await getDeviceDetails();
    final key = Key.fromUtf8(deviceInfo[2]); //identifier
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);

    Encrypted encrypted = Encrypted.fromBase64(encryptedBase64);
    final decrypted = encrypter.decrypt(encrypted,iv:iv);

    return decrypted;
  }
}


