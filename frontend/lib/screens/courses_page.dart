import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'course_detail_page.dart';
import 'package:logger/logger.dart';
import '../services/iclient_service.dart';
import '../models/course.dart'; // Import your Course model

class CoursesPage extends StatefulWidget {
  final IClientService clientService;

  CoursesPage({Key? key, required this.clientService}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    var logger = Logger();

    super.initState();
    _coursesFuture = widget.clientService
        .getRequest('/enrollments?user_id=123')
        .then((data) {
      if (data != null && data['courses'] != null) {
        var courseList = List<Course>.from(
            data['courses'].map((course) => Course.fromJson(course)));
        return courseList;
      }
      return <Course>[]; // Return an empty list if data is missing or null
    });

    _coursesFuture.then((courses) {
      logger.i('Courses loaded: ${courses.length}');
    });

    _coursesFuture.catchError((error) {
      logger.e('Error loading courses: $error');
      return <Course>[];
    });

    _coursesFuture.then((courses) {
      for (var course in courses) {
        logger.i('Course: ${course.title}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Enrolled Courses"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("No enrolled courses available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Course course = snapshot.data![index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: course.thumbnail_url,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      ListTile(
                        title: Text(course.title),
                        subtitle: Text(course.short_description),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailPage(
                                    course: course,
                                    client: widget.clientService),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(course.instructor),
                            Text('${course.rating.toStringAsFixed(1)} ⭐️'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
