import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'metamask_interaction.dart';
import 'dart:io';
import 'dart:js' as js;

class RpcWrapper{
  Future<String?> getUserToken(String address, String name, String url) async
  {
    final file = File(_user_path);
    final jsonContent = await file.readAsString();
    final contractJson = jsonDecode(jsonContent);

    final abi = jsonEncode(contractJson['abi']);
    final bytecode = contractJson['bytecode'];
    final args = [name, url];

    final contractAddress = js.context.callMethod('deployContract', [abi, bytecode, args]);
    print('Contract deployed at: $contractAddress');

    return null;
  }

  final rpcUrl = 'https://api.avax-test.network/ext/bc/C/rpc';
  final String _user_path = "/home/Jlisowskyy/Storage/Repos/AngelHack_solution/Avalanche/avalanche-starter-kit/out/user_contract.sol/UserContract.json";
}