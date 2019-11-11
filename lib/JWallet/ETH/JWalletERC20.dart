import 'package:jwallet_core/Error.dart';

import '../JWalletBase.dart';
import './JWalletETH.dart';
import './Model/e_r_c20_token_info.dart' as $erc20;
import './Model/e_t_h_history.dart' as $history;
import 'package:jubiter_plugin/gen/Jub_Ethereum.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Ethereum.pbserver.dart';

import 'package:jubiter_plugin/gen/Jub_Common.pb.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbenum.dart';
import 'package:jubiter_plugin/gen/Jub_Common.pbserver.dart';
import '../../JKeyStroe/interface/JInterfaceKeyStore.dart';

import 'package:jubiter_plugin/jubiter_plugin.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import './Model/account_info.dart';


class JWalletERC20 extends JWalletETH{

  $erc20.Data _erc20Info;
  JWalletERC20(JWalletETH ethWallet,$erc20.Data erc20Info):super(ethWallet.name,ethWallet.mainPath,ethWallet.endPoint,ethWallet.keyStore){
    wType = WalletType.ETH;
    _erc20Info = erc20Info;
    address = ethWallet.getAddress();
  }

   //Json构造函数
  JWalletERC20.fromJson(Map<String, dynamic> json):
  super.fromJson(json){
      _erc20Info = $erc20.Data.fromJson(json["erc20Info"]);
    //构造子类特有数据
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    //增加子类的json化数据，地址、历史等等
    json["erc20Info"] = _erc20Info;
    return json;
  }

  @override
  Map<String, dynamic> toJsonKey(){
    Map<String, dynamic> json = super.toJsonKey();
    json["erc20Info"] = _erc20Info;
    return json;
  }

  $erc20.Data get erc20Info {
    return _erc20Info;
  }

  @override
  Future<AccountInfo> getAccountInfo() async{
    return getAccountInfoGeneric(getAddress(),erc20address:_erc20Info.tokenAddr);
  }

  @override
  Future<String> getBalance() async{
      var accountInfo = await getAccountInfoGeneric(getAddress(),erc20address:_erc20Info.tokenAddr);
      return Future<String>.value(accountInfo.data.balance);
  }

  @override
  Future<List<$erc20.Data>> getAllERC20Tokens(String keyword,int pageNumber ,int pageSize) async{
    throw JUBR_IMPL_NOT_SUPPORT;
  }

  @override
  Future<bool> addERC20Token($erc20.Data token) async{
    throw JUBR_IMPL_NOT_SUPPORT;
  }

  @override
  List<String> enumAddedERC20Tokens(){
    throw JUBR_IMPL_NOT_SUPPORT;
  }
 
  @override
  Future<bool> removeERC20Token(String wallet){
    throw JUBR_IMPL_NOT_SUPPORT;
  }

  @override
  Future<List<$history.TxList>> getCloudHistory(int pageSize,{$history.TxList lastTX}){
    return getCloudHistoryGeneric(pageSize,tokenInfo:_erc20Info,lastTX:lastTX);
  }

  //底层的ETHBuildERC20Abi接口需要修改，增加外部设置token数据的功能
  Future<ResultString> buildERC20Abi($erc20.Data info,String address, String amountInWei) async {
    return JuBiterPlugin.ETHBuildERC20Abi(contextID, address, amountInWei);
  }


  @override
  Future<TransactionETH> buildTx(String to,String valueInWei,String gasPriceInWei,String input) async{
    var rv = await buildERC20Abi(_erc20Info,to,valueInWei);
    if(rv.stateCode != JUBR_OK) throw rv.stateCode;

    Bip32Path bip32path = Bip32Path.create();
    bip32path.change = false;
    bip32path.addressIndex = $fixnum.Int64(0);


    TransactionETH txInfo = TransactionETH.create();
    txInfo.path = bip32path;
    txInfo.nonce = (await getNonce()).item1;
    txInfo.gasLimit = int.parse(_erc20Info.tokenGasusedMax);
    txInfo.gasPriceInWei = gasPriceInWei;
    txInfo.to = _erc20Info.tokenAddr;
    txInfo.valueInWei = valueInWei;
    txInfo.input = rv.value;
    return Future<TransactionETH>.value(txInfo);
  }
}