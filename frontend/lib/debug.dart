import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:http/http.dart' as http;

// import 'screens/home_page.dart';
import 'screens/debug_server.dart';
import 'services/backend_service.dart';

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
      home: HomePage(),
      routes: {
        '/debug': (context) => DebugServerTestPage(
                client: BackendService(
              'http://192.168.0.143:5000',
            )),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/debug');
          },
          child: Text('Go to Debug Server Test'),
        ),
      ),
    );
  }
}
