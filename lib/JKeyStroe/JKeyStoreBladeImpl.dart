import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';
import 'package:jubiter_plugin/gen/jubiterblue.pbserver.dart';
import 'package:jubiter_plugin/jubiter_plugin.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';
import 'package:jubiter_plugin/gen/google/protobuf/any.pb.dart';

class JKeyStoreBladeImpl implements JInterfaceKeyStore{
  KeyStoreType _type;
  String _uuid;

  //默认构造函数
  JKeyStoreBladeImpl(String uuid){
      _type = KeyStoreType.Blade;
      _uuid = uuid;
  }

  //Json构造函数
  JKeyStoreBladeImpl.fromJson(Map<String, dynamic> json):
  _type = KeyStoreType.values[json["kType"]],
  _uuid = json["uuid"];

  Map<String, dynamic> toJson() =>
  {
    'kType': _type.index,
    'uuid': _uuid
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'kType': _type.index,
  };

  updateSelf(){}

  //通用函数
  KeyStoreType type(){return _type;}
  String getUUID(){return _uuid;}
  Future<bool> init() async{return Future<bool>.value(true);}
  String getXprv(){throw JUBR_IMPL_NOT_SUPPORT;}
  Future<bool> verifyPin(int contextID,String password) async{
    var rv = await JuBiterWallet.verifyPIN(contextID, password);
    if(rv.stateCode != JUBR_OK) return Future<bool>.value(false);
    return Future<bool>.value(true);
  }

  //蓝牙相关函数
  static Future<int> initDevice() async {
    return JuBiterWallet.initDevice();
  }

  static Stream<ScanResult> startScan(Duration timeout) async*{
    yield* JuBiterWallet.startScan(timeout);
  }

  static Future<int> stopScan() async {
    return JuBiterWallet.stopScan();
  }

  static Future<int> connect(
    BluetoothDevice device,
    Duration timeout,
    void onConnectStateChange(DeviceStateResponse state),
    void onError(Object error)) async {
    return JuBiterWallet.connect(device, timeout, onConnectStateChange, onError);
  }


  static Future<int> cancelConnect(String macAddress) async {
    return JuBiterWallet.cancelConnect(macAddress);
  }

  static Future<int> disconnectDevice(int deviceID) async {
    return JuBiterWallet.disconnectDevice(deviceID);
  }

  static Future<bool> isConnected(int deviceID) async {
    return JuBiterWallet.isConnected(deviceID);
  }

  static Future<DeviceInfo> getDeviceInfo(int deviceID) async {
    var resultAny = await JuBiterWallet.getDeviceInfo(deviceID);
    if(resultAny.stateCode != JUBR_OK) throw resultAny.stateCode;
    List<Any> detail = resultAny.value;
    for(var data in detail) {
      //只有一个
      DeviceInfo info = DeviceInfo.create();
      data.unpackInto(info);
      return Future<DeviceInfo>.value(info);
    }
    throw JUBR_ERROR;
  }
}