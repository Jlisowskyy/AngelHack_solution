import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

// import 'screens/home_page.dart';
import 'screens/debug_server.dart';
import 'services/backend_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Unrot',
      home: const HomePage(),
      routes: {
        '/debug': (context) => DebugServerTestPage(
                client: BackendService(
              'http://127.0.0.1:8000/',
            )),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/debug');
          },
          child: const Text('Go to Debug Server Test'),
        ),
      ),
    );
  }
}
