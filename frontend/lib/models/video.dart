/// A class to represent a video in the application and database.
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
      id: json['id'] is String ? int.parse(json['id']) : json['id'].toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      video_url: json['video_url'] as String ??
          'https://example.com/default_video.mp4',
      thumbnail_url: json['thumbnail_url'] as String ??
          'https://example.com/default_thumbnail.jpg',
      course_id: json['course_id'] is String
          ? int.parse(json['course_id'])
          : json['course_id'].toInt(),
      num_likes: json['num_likes'] is String
          ? int.parse(json['num_likes'])
          : json['num_likes'].toInt(),
      num_views: json['num_views'] is String
          ? int.parse(json['num_views'])
          : json['num_views'].toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'description': description,
      'video_path': video_url,
      'thumbnailPath': thumbnail_url,
      'course_id': course_id,
      'num_likes': num_likes.toString(),
      'num_views': num_views.toString(),
    };
  }
}
