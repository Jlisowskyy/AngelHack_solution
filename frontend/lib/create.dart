import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'screens/create_account.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Unrot',
      home: CreateAccountPage(),
    );
  }
}
