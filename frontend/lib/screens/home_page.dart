import 'package:flutter/material.dart';

import 'account_page.dart';
import 'video_scroller_page.dart';
import 'courses_page.dart';
import 'search_courses_page.dart';

import '../services/iclient_service.dart';
import '../services/mock_client.dart';
import '../services/backend_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBarItemIndex = 0;

  IClientService? clientService;
  late List<Widget> _pages = [];

  // Default constructor
  _HomePageState() {
    clientService = BackendService('http://127.0.0.1:8000/');
    assert(clientService != null);

    _pages = [
      VideoPlayerScreen(client: clientService!),
      SearchCoursesPage(client: clientService!),
      CoursesPage(clientService: clientService!),
      AccountPage(),
    ];
  }

  void _onBarItemTapped(int index) {
    setState(() {
      _currentBarItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentBarItemIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Courses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'My Account'),
        ],
        currentIndex: _currentBarItemIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey[600],
        onTap: _onBarItemTapped,
      ),
    );
  }
}
