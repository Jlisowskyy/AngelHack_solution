import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../models/video.dart' as video_model;
import '../models/course.dart';
import '../services/iclient_service.dart';
import 'course_detail_page.dart';
import 'video_description_page.dart'; // Make sure to import the video description page

class VideoDetailPage extends StatefulWidget {
  final video_model.Video video;
  final IClientService client;

  const VideoDetailPage({Key? key, required this.video, required this.client})
      : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late Player player;
  late VideoController controller;
  late int _currentVideoIndex;
  late Future<List<video_model.Video>> _videosFuture;
  late List<video_model.Video> _videos;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    _currentVideoIndex = 0;
    _videosFuture = _fetchCourseVideos();

    // Pre-fetch videos and autoplay the first video
    _videosFuture.then((videos) {
      if (videos.isNotEmpty) {
        setState(() {
          _videos = videos;
          _openVideoAtIndex(0); // Autoplay the first video
        });
      }
    });

    player.stream.completed.listen((event) {
      if (player.state.completed) {
        _onVideoEnd();
      }
    });
  }

  Future<List<video_model.Video>> _fetchCourseVideos() async {
    final data = await widget.client
        .getRequest('videos?course_id=${widget.video.course_id}');
    if (data != null && data['videos'] != null) {
      return List<video_model.Video>.from(
          data['videos'].map((video) => video_model.Video.fromJson(video)));
    }
    return <video_model.Video>[];
  }

  void _onVideoEnd() {
    if (_currentVideoIndex < _videos.length - 1) {
      setState(() {
        _currentVideoIndex++;
        _openVideoAtIndex(_currentVideoIndex);
      });
    }
  }

  void _openVideoAtIndex(int index) {
    if (_videos.isNotEmpty && index < _videos.length) {
      player.open(Media(_videos[index].video_url));
    }
    Future.delayed(Duration(milliseconds: 500), () {
      player.play();
    });
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
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No videos available"));
          }

          _videos = snapshot.data!;
          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _videos.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentVideoIndex = index;
                    _openVideoAtIndex(index); // Autoplay the new video
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoDescriptionPage(video: _videos[index]),
                          ),
                        );
                      }
                    },
                    child: Center(
                      child: Video(
                        controller: controller,
                        controls: MaterialVideoControls,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
