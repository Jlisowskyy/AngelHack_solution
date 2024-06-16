import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:frontend/models/course.dart';
import 'package:frontend/screens/course_detail_page.dart';
import 'package:frontend/services/iclient_service.dart';
import 'package:logger/logger.dart';
import '../models/video.dart' as video_model;

class VideoPlayerScreen extends StatefulWidget {
  final IClientService client;

  VideoPlayerScreen({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late Player player;
  late media_kit_video.VideoController controller;
  late int _currentVideoIndex;
  late Logger logger;

  late Future<List<video_model.Video>> _videosFuture;
  late List<video_model.Video> _videos;

  @override
  void initState() {
    super.initState();
    _videosFuture = _getVideos();

    logger = Logger();
    player = Player();
    controller = media_kit_video.VideoController(player);

    // Initialize _currentVideoIndex
    _currentVideoIndex = 0;

    // Listen for video end
    player.stream.completed.listen(
      (event) {
        if (player.state.completed) {
          _onVideoEnd();
        }
      },
    );
  }

  Future<List<video_model.Video>> _getVideos() async {
    try {
      final data = await widget.client.getRequest('/videos');
      if (data != null && data['videos'] != null) {
        var videoList = List<video_model.Video>.from(
            data['videos'].map((video) => video_model.Video.fromJson(video)));
        return videoList;
      }
      return <video_model
          .Video>[]; // Return an empty list if data is missing or null
    } catch (error) {
      logger.e('Error loading videos: $error');
      return <video_model.Video>[];
    }
  }

  void _onVideoEnd() {
    if (_currentVideoIndex < _videos.length - 1) {
      setState(() {
        _currentVideoIndex++;
        _openCurrentVideo();
      });
    }
  }

  void _openCurrentVideo() {
    player.open(Media(_videos[_currentVideoIndex].video_url));
  }

  Future<void> _navigateToCoursePage() async {
    try {
      final courseId = _videos[_currentVideoIndex].course_id.toString();
      final courseData =
          await widget.client.getRequest('/courses?course_id=${courseId}');
      final course = Course.fromJson(courseData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CourseDetailPage(course: course, client: widget.client),
        ),
      );
    } catch (error) {
      logger.e('Failed to load course: $error');
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<video_model.Video>>(
        future: _videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No videos available'));
          }

          _videos = snapshot.data!;

          // Open the first video by default
          if (_currentVideoIndex == 0) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _openCurrentVideo();
            });
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            onPageChanged: (index) {
              setState(() {
                _currentVideoIndex = index;
                _openCurrentVideo();
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    // User swiped right
                    _navigateToCoursePage();
                  }
                },
                child: Center(
                  child: media_kit_video.MaterialVideoControlsTheme(
                    normal: media_kit_video.MaterialVideoControlsThemeData(
                      displaySeekBar: false,
                      automaticallyImplySkipNextButton: false,
                      automaticallyImplySkipPreviousButton: false,
                      primaryButtonBar: [
                        media_kit_video.MaterialPlayOrPauseButton(),
                      ],
                    ),
                    fullscreen: media_kit_video.MaterialVideoControlsThemeData(
                      displaySeekBar: false,
                      automaticallyImplySkipNextButton: false,
                      automaticallyImplySkipPreviousButton: false,
                      primaryButtonBar: [
                        media_kit_video.MaterialPlayOrPauseButton(),
                      ],
                    ),
                    child: media_kit_video.Video(
                      controller: controller,
                      controls: media_kit_video.MaterialVideoControls,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
