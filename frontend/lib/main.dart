import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Brain Unrot',
      home: HomePage(),
    );
  }
}
