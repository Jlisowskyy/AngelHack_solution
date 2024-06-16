/// A class to represent a user in the application and database.
class User {
  final String user_token_id;
  final String name;
  final String email;
  final String profile_picture_url;

  User({
    required this.user_token_id,
    required this.name,
    required this.email,
    required this.profile_picture_url,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_token_id: json['user_token_id'],
      name: json['name'],
      email: json['email'],
      profile_picture_url: json['profile_picture_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_token_id': user_token_id,
      'name': name,
      'email': email,
      'profile_picture': profile_picture_url,
    };
  }
}
