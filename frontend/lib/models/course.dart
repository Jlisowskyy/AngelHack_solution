
/// A class to represent a course in the application and database.
class Course {
  final String id;
  final String title;
  final String short_description;
  final String description;
  final String category;
  final String instructor;
  final String duration;
  final String thumbnail_url;
  final String image_url;
  final double rating;
  final double price;

  Course({
    required this.id,
    required this.title,
    required this.short_description,
    required this.description,
    required this.category,
    required this.instructor,
    required this.duration,
    required this.thumbnail_url,
    required this.image_url,
    required this.rating,
    required this.price,
  });

  static double _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? -1.0;
    } else if (value is num) {
      return value.toDouble();
    } else {
      return -1.0;
    }
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      short_description: json['short_description'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      instructor: json['instructor'] as String,
      duration: json['duration'] as String,
      thumbnail_url: json['thumbnail_url'] ??
          'https://example.com/default_thumbnail.jpg', // Default thumbnail
      image_url: json['image_url'] ?? 'https://example.com/default_image.jpg',
      rating: _parseDouble(json['rating']),
      price: _parseDouble(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'short_description': short_description,
      'description': description,
      'category': category,
      'instructor': instructor,
      'duration': duration,
      'thumbnail_url': thumbnail_url,
      'rating': rating.toString(),
      'price': price.toString(),
    };
  }
}
