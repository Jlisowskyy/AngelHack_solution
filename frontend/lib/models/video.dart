import 'dart:convert';

class Video {
  final int id;
  final String title;
  final String description;
  final String video_url;
  final String thumbnail_url;
  final int course_id;
  final int num_likes;
  final int num_views;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.video_url,
    required this.thumbnail_url,
    required this.course_id,
    required this.num_likes,
    required this.num_views,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: _parseInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      video_url: json['video_url'] ?? 'https://example.com/default_video.mp4',
      thumbnail_url:
          json['thumbnail_url'] ?? 'https://example.com/default_thumbnail.jpg',
      course_id: _parseInt(json['course_id']),
      num_likes: _parseInt(json['num_likes']),
      num_views: _parseInt(json['num_views']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_url': video_url,
      'thumbnail_url': thumbnail_url,
      'course_id': course_id,
      'num_likes': num_likes,
      'num_views': num_views,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else {
      return 0;
    }
  }
}
