/// A class to represent a user_id - course_id relationship in the application and database.
class EnrolledCourse {
  final String id;
  final String user_id;
  final String course_id;

  EnrolledCourse({
    required this.id,
    required this.user_id,
    required this.course_id,
  });

  factory EnrolledCourse.fromJson(Map<String, dynamic> json) {
    return EnrolledCourse(
      id: json['id'],
      user_id: json['user_id'],
      course_id: json['course_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'course_id': course_id,
    };
  }
}
