/// A class to represent a user in the application and database.
class User {
  final String id;
  final String name;
  final String email;
  final String profile_picture_url;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profile_picture_url,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile_picture_url: json['profile_picture_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_picture': profile_picture_url,
    };
  }
}
