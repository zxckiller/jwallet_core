//所有KeyStore都需要实现此接口,为了上层使用方便，此接口会混合所有软硬操作的接口
enum KeyStoreType { Blade, LocalDB}
abstract class JInterfaceKeyStore {
  KeyStoreType type();
  String connectDevice();
  String openDB();

  Map<String, dynamic> toJson();

}