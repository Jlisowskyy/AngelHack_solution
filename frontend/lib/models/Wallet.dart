import 'Logged_user.dart';
import '../services/db_wrapper.dart';
import '../screens/create_account.dart';

import 'package:flutter/material.dart';



class Wallet {
  static void login(BuildContext context, String addr)
  {    
    address = addr;
    String? contractId = db_wrapper.getUserContractId(addr);
    if (contractId == null)
    {
      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateAccountPage(),
              ),
            );
    }

  }

  static String? address;
}