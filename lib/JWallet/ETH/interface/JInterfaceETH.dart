import 'package:jubiter_plugin/gen/Jub_Ethereum.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbjson.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbserver.dart';

import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbjson.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';
//所有ETH钱包都需要实现此接口
abstract class JInterfaceETH {
  //获取地址
  Future<ResultString> getAddress(Bip32Path path);
  //签名
  Future<ResultString> signTX(TransactionETH txInfo);
  //获取主公钥
  Future<ResultString> getMainHDNode(ENUM_PUB_FORMAT format);
  //获取某个Path的公钥
  Future<ResultString> getHDNode(ENUM_PUB_FORMAT format,Bip32Path path);
}