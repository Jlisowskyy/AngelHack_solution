import 'package:flutter/material.dart';
import 'package:frontend/models/course.dart';
import 'package:frontend/services/iclient_service.dart';
import 'course_detail_page.dart';

class SearchCoursesPage extends StatefulWidget {
  final IClientService client;

  SearchCoursesPage({Key? key, required this.client}) : super(key: key);

  @override
  _SearchCoursesPageState createState() => _SearchCoursesPageState();
}

class _SearchCoursesPageState extends State<SearchCoursesPage> {
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {
    final data = await widget.client.getRequest('courses');
    if (data != null && data['courses'] != null) {
      return List<Course>.from(
          data['courses'].map((course) => Course.fromJson(course)));
    }
    return <Course>[]; // Return an empty list if data is missing or null
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Courses'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No courses available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var course = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  child: ListTile(
                    leading: Image.network(
                      course.thumbnail_url,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return CircularProgressIndicator();
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                    title: Text(course.title, style: textTheme.titleMedium),
                    subtitle: Text(course.short_description,
                        style: textTheme.bodyMedium),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                              course: course, client: widget.client),
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
    );
  }
}
