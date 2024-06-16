import 'package:flutter/material.dart';
import 'video_player_screen.dart';

class VideoScroller extends StatefulWidget {
  @override
  _VideoScrollerState createState() => _VideoScrollerState();
}

class _VideoScrollerState extends State<VideoScroller> {
  int _currentVideoIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

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

  void _onVideoEnd() {
    if (_currentVideoIndex < videoPaths.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
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
    );
  }
}
