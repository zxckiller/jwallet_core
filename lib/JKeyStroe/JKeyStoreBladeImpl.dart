import "./interface/JInterfaceKeyStore.dart";
import '../Error.dart';
import 'package:jubiter_plugin/gen/jubiterblue.pbserver.dart';
import 'package:jubiter_plugin/jubiter_plugin.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';
import 'package:jubiter_plugin/gen/google/protobuf/any.pb.dart';

class JKeyStoreBladeImpl implements JInterfaceKeyStore{
  KeyStoreType _type;
  String _deviceSN;

  //默认构造函数
  JKeyStoreBladeImpl(String deviceSN){
      _type = KeyStoreType.Blade;
      _deviceSN = deviceSN;
  }

  //Json构造函数
  JKeyStoreBladeImpl.fromJson(Map<String, dynamic> json):
  _type = KeyStoreType.values[json["kType"]],
  _deviceSN = json["deviceSN"];

  Map<String, dynamic> toJson() =>
  {
    'kType': _type.index,
    'deviceSN': _deviceSN
  };

  Map<String, dynamic> toJsonKey() =>
  {
    'kType': _type.index,
  };

  updateSelf(){}

  //通用函数
  KeyStoreType type(){return _type;}
  Future<bool> init() async{return Future<bool>.value(true);}
  String getXprv(){throw JUBR_IMPL_NOT_SUPPORT;}
  Future<bool> verifyPin(String password){return Future<bool>.value(true);}

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