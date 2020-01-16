//所有BTC钱包，都需要实现此接口
abstract class JInterfaceBTC {
  //获取地址
  String getAddress();
  //获取xpub，ypub,zpub等各种xpub
  String getXpub();
  //获取本地钱包余额
  String getLocalBalance();
  //获取链上钱包余额
  Future<String> getCloudBalance();
}