import 'dart:async';
import 'dart:convert';

import 'iclient_service.dart';

class MockClient implements IClientService {
  static const _coursesData = {
    'courses': [
      {
        'id': '1',
        'title': 'Introduction to Flutter',
        'short_description': 'Learn the basics of Flutter.',
        'description':
            "Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. Learn the basics of Flutter for effective mobile development.",
        'category': 'Mobile Development',
        'instructor': 'Jane Adams',
        'duration': '5 hours',
        'thumbnail_url':
            'https://i.pinimg.com/736x/af/44/ea/af44ea07fa5bfd828004747f62f63bc3.jpg',
        'rating': 4.5
      },
      {
        'id': '2',
        'title': 'Introduction to React',
        'short_description': 'Learn the basics of React.',
        'description':
            "React is a JavaScript library for building user interfaces. It's maintained by Facebook and a community of individual developers and companies.",
        'category': 'Web Development',
        'instructor': 'Johny Smith',
        'duration': '3 hours',
        'thumbnail_url':
            'https://www.pngitem.com/pimgs/m/146-1468479_react-logo-png-react-js-transparent-png.png',
        'rating': 4.0
      }
    ]
  };

  static const _videosData = {
    'videos': [
      {
        'id': '101',
        'title': 'Flutter Setup',
        'description': 'How to set up your Flutter development environment.',
        'thumbnail_url': 'https://example.com/flutter_setup.jpg',
        'course_id': '1',
        'video_url': 'assets/videos/video1.mp4',
        'num_likes': 150,
        'num_views': 1000
      },
      {
        'id': '102',
        'title': 'React Setup',
        'description': 'How to set up your React development environment.',
        'thumbnail_url': 'https://example.com/react_setup.jpg',
        'course_id': '2',
        'video_url': 'assets/videos/video2.mp4',
        'num_likes': 120,
        'num_views': 900
      }
    ]
  };

  static const _enrollmentsData = {
    'enrollments': [
      {
        'id': 'e1',
        'user_id': '123', // John Doe
        'course_id': '1', // Introduction to Flutter
      },
      {
        'id': 'e2',
        'user_id': '123', // John Doe
        'course_id': '2', // Introduction to React
      },
      {
        'id': 'e3',
        'user_id': '124', // Another User
        'course_id': '1',
      }
    ]
  };

  @override
  Future<Map<String, dynamic>> getRequest(String endpoint) async {
    if (endpoint.startsWith("/courses")) {
      return Future.delayed(Duration(seconds: 1), () => _coursesData);
    } else if (endpoint.startsWith("/videos")) {
      var courseId = Uri.parse(endpoint).queryParameters['course_id'];

      if (courseId == null) {
        var videos = _videosData['videos'];
        return Future.delayed(Duration(seconds: 1), () => {'videos': videos});
      }
      var videos = _videosData['videos']
          ?.where((video) => video['course_id'] == courseId)
          .toList();
      return Future.delayed(Duration(seconds: 1), () => {'videos': videos});
    } else if (endpoint.startsWith("/users")) {
      return Future.delayed(
          Duration(seconds: 1),
          () => {
                'id': '123',
                'name': 'John Doe',
                'email': 'john.doe@example.com',
                'profile_picture':
                    'https://t4.ftcdn.net/jpg/06/08/55/73/360_F_608557356_ELcD2pwQO9pduTRL30umabzgJoQn5fnd.jpg'
              });
    } else if (endpoint.startsWith("/enrollments")) {
      var userId = Uri.parse(endpoint).queryParameters['user_id'];
      var enrolledCourseIds = _enrollmentsData['enrollments']
          ?.where((enrollment) => enrollment['user_id'] == userId)
          .map((enrollment) => enrollment['course_id'])
          .toList();
      if (enrolledCourseIds == null) return Future.value({'courses': []});

      var enrolledCourses = _coursesData['courses']
          ?.where((course) => enrolledCourseIds.contains(course['id']))
          .toList();
      return Future.delayed(
          Duration(seconds: 1), () => {'courses': enrolledCourses});
    }
    throw Exception("Endpoint not found");
  }

  @override
  Future<Map<String, dynamic>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    return Future.delayed(Duration(seconds: 1), () => {'status': 'success'});
  }
}
