import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/models/course.dart';
import 'package:frontend/services/iclient_service.dart';
import 'package:logger/logger.dart';

import 'video_detail_page.dart';
import '../models/video.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  final IClientService client;

  const CourseDetailPage({Key? key, required this.course, required this.client})
      : super(key: key);

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late Future<List<Video>> _videosFuture;

  @override
  void initState() {
    super.initState();
    var logger = Logger();

    // Prompt database for video data
    _videosFuture = widget.client
        .getRequest('/videos?course_id=${widget.course.id}')
        .then((data) {
      if (data != null && data['videos'] != null) {
        var videoList = List<Video>.from(
            data['videos'].map((video) => Video.fromJson(video)));
        return videoList;
      }
      return <Video>[]; // Return an empty list if data is missing or null
    });

    _videosFuture.then((videos) {
      logger.i('Videos loaded: ${videos.length}');
    }).catchError((error) {
      logger.e('Error loading videos: $error');
      return <Video>[];
    });

    _videosFuture.then((videos) {
      for (var video in videos) {
        logger.i('Video: ${video.title}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title, style: textTheme.titleLarge),
        backgroundColor:
            Colors.deepPurple, // Stylish and thematic app bar color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.course.thumbnail_url,
              width: MediaQuery.of(context).size.width,
              height: 250, // Slightly larger image for more impact
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error_outline, size: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.course.title,
                      style: textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: widget.course.rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Instructor: ${widget.course.instructor}',
                          style: textTheme.titleMedium),
                      Text('Duration: ${widget.course.duration}',
                          style: textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Course Description",
                      style: textTheme.titleSmall
                          ?.copyWith(color: Colors.deepPurple)),
                  Text(widget.course.description, style: textTheme.bodyLarge),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Course Videos',
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            FutureBuilder<List<Video>>(
              future: _videosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No videos available"));
                }

                return ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable scrolling inside the list
                  shrinkWrap: true, // Take only the space needed
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var video = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4.0,
                        child: ListTile(
                          leading: Image.network(
                            video.thumbnail_url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error_outline),
                          ),
                          title:
                              Text(video.title, style: textTheme.titleMedium),
                          subtitle: Text(video.description,
                              style: textTheme.bodyMedium),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoDetailPage(
                                    video: video, client: widget.client),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
