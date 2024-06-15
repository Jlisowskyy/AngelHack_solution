import 'package:flutter/material.dart';
import 'video_player_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBarItemIndex = 0;
  int _currentVideoIndex = 0;
  final int swipeDelta = 7;

  PageController _pageController = PageController(initialPage: 1);

  List<String> videoPaths = [
    'assets/videos/video1.mp4',
    'assets/videos/video2.mp4',
    'assets/videos/video3.mp4',
    'assets/videos/video4.mp4',
    'assets/videos/video5.mp4',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentVideoIndex = index;
    });
  }

  void _onBarItemTapped(int index) {
    setState(() {
      _currentBarItemIndex = index;
    });
  }

  void _onVideoEnd() {
    if (_currentVideoIndex < videoPaths.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brain Unrot'),
      ),
      body: PageView.builder(
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: videoPaths.length,
        itemBuilder: (context, index) {
          return VideoPlayerScreen(
            videoPath: videoPaths[index],
            onVideoEnd: _onVideoEnd,
          );
        },
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
