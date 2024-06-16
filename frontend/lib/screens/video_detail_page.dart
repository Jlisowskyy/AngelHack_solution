import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../models/video.dart' as video_model;

class VideoDetailPage extends StatefulWidget {
  final video_model.Video video;

  const VideoDetailPage({Key? key, required this.video}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late Player player;
  late VideoController controller;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    player.open(Media(widget.video.video_url));

    // Listen for video end
    player.stream.completed.listen((event) {
      if (player.state.completed) {
        // Handle video end
      }
    });
  }

  @override
  void didUpdateWidget(covariant VideoDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.video.video_url != oldWidget.video.video_url) {
      player.open(Media(widget.video.video_url));
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title, style: textTheme.titleLarge),
        backgroundColor:
            Colors.deepPurple, // Stylish and thematic app bar color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Video(
                controller: controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.video.title,
                      style: textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(widget.video.description, style: textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Likes: ${widget.video.num_likes}',
                          style: textTheme.bodyMedium),
                      Text('Views: ${widget.video.num_views}',
                          style: textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
