import 'package:flutter/material.dart';
import 'account_page.dart';
import 'video_scroller_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBarItemIndex = 0;
  final List<Widget> _pages = [
    VideoScroller(),
    Scaffold(body: Center(child: Text('Search Page'))),
    Scaffold(body: Center(child: Text('Courses Page'))),
    Scaffold(body: Center(child: Text('Wishlist Page'))),
    AccountPage(),
  ];

  void _onBarItemTapped(int index) {
    setState(() {
      _currentBarItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brain Unrot'),
      ),
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
              icon: Icon(Icons.favorite), label: 'Wishlist'),
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
