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
  String getAddress(Bip32Path path);
}