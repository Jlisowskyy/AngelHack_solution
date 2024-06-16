import 'package:flutter/material.dart';
import '../models/video.dart' as video_model;

class VideoDescriptionPage extends StatelessWidget {
  final video_model.Video video;

  const VideoDescriptionPage({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(video.title, style: textTheme.titleLarge),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(video.title,
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(video.description, style: textTheme.bodyLarge),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Likes: ${video.num_likes}',
                      style: textTheme.bodyMedium),
                  Text('Views: ${video.num_views}',
                      style: textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
