library metamask_interaction;

import 'dart:js' as js;

void connectMetaMask() {
  js.context.callMethod('connectMetaMask');
}

void deployContract(List<dynamic> abi, String bytecode, List<dynamic> args) {
  js.context.callMethod('deployContract', [abi, bytecode, args]);
}