import 'Logged_user.dart';

class Wallet {
  Wallet._privateConstructor();

  // TODO: ADD LOGIN LOGIC HERE
  static void login()
  {
    _instance = Wallet._privateConstructor();
    
    /*
        LOGIN
    
     */


  }

  static Wallet? _instance;

  static Wallet? get instance => _instance;

  final String _address = "";

  String getAddress() {
    return _address;
  }

}