import '../models/user.dart';

class Logged_user {
  Logged_user._privateConstructor();

  void loadUser(User user)
  {

  }

  static final Logged_user? _instance = null;

  static Logged_user? get instance => _instance;
  User? _user;
}