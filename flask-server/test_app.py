import unittest
import json
from app import app, db, VideoModel, CourseModel, User, CourseVideoModel, UserCourseModel, InstructorCourseModel

class APITestCase(unittest.TestCase):

    def setUp(self):
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test_database.db'
        self.app = app.test_client()
        with app.app_context():
            db.create_all()

    def tearDown(self):
        with app.app_context():
            db.drop_all()

    def test_create_and_get_video(self):
        # Create a user first
        user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }
        self.app.put('/user/user1', data=json.dumps(user_data), content_type='application/json')

        # Create a course first
        course_data = {
            'id': 'course1',
            'title': 'Course 1',
            'description': 'A sample course',
            'short_description': 'Sample short description',
            'category': 'Category 1',
            'duration': '10 hours',
            'thumbnail_path': 'path/to/thumbnail',
            'rating': 4.5,
            'istructor_id': 'user1'
        }
        self.app.put('/course/course1', data=json.dumps(course_data), content_type='application/json')

        # Create a video
        video_data = {
            'id': 'video1',
            'title': 'Video 1',
            'num_likes': 10,
            'num_views': 100,
            'description': 'A sample video',
            'video_path': 'path/to/video',
            'thumbnail_path': 'path/to/thumbnail',
            'premium': False,
            'course_id': 'course1'
        }
        response = self.app.put('/video/video1', data=json.dumps(video_data), content_type='application/json')
        self.assertEqual(response.status_code, 201)

        # Get the video
        response = self.app.get('/video/video1')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['id'], 'video1')

    def test_delete_video(self):
        # Create a user first
        user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }
        self.app.put('/user/user1', data=json.dumps(user_data), content_type='application/json')

        # Create a course first
        course_data = {
            'id': 'course1',
            'title': 'Course 1',
            'description': 'A sample course',
            'short_description': 'Sample short description',
            'category': 'Category 1',
            'duration': '10 hours',
            'thumbnail_path': 'path/to/thumbnail',
            'rating': 4.5,
            'istructor_id': 'user1'
        }
        self.app.put('/course/course1', data=json.dumps(course_data), content_type='application/json')

        # Create a video
        video_data = {
            'id': 'video1',
            'title': 'Video 1',
            'num_likes': 10,
            'num_views': 100,
            'description': 'A sample video',
            'video_path': 'path/to/video',
            'thumbnail_path': 'path/to/thumbnail',
            'premium': False,
            'course_id': 'course1'
        }
        self.app.put('/video/video1', data=json.dumps(video_data), content_type='application/json')

        # Delete the video
        response = self.app.delete('/video/video1')
        self.assertEqual(response.status_code, 204)

        # Verify the video is deleted
        response = self.app.get('/video/video1')
        self.assertEqual(response.status_code, 404)

    def test_create_and_get_course(self):
        # Create a user first
        user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }
        self.app.put('/user/user1', data=json.dumps(user_data), content_type='application/json')

        course_data = {
            'id': 'course1',
            'title': 'Course 1',
            'description': 'A sample course',
            'short_description': 'Sample short description',
            'category': 'Category 1',
            'duration': '10 hours',
            'thumbnail_path': 'path/to/thumbnail',
            'rating': 4.5,
            'istructor_id': 'user1'
        }
        response = self.app.put('/course/course1', data=json.dumps(course_data), content_type='application/json')
        self.assertEqual(response.status_code, 201)

        response = self.app.get('/course/course1')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['id'], 'course1')

    def test_delete_course(self):
        # Create a user first
        user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }
        self.app.put('/user/user1', data=json.dumps(user_data), content_type='application/json')

        course_data = {
            'id': 'course1',
            'title': 'Course 1',
            'description': 'A sample course',
            'short_description': 'Sample short description',
            'category': 'Category 1',
            'duration': '10 hours',
            'thumbnail_path': 'path/to/thumbnail',
            'rating': 4.5,
            'istructor_id': 'user1'
        }
        self.app.put('/course/course1', data=json.dumps(course_data), content_type='application/json')

        response = self.app.delete('/course/course1')
        self.assertEqual(response.status_code, 204)

        response = self.app.get('/course/course1')
        self.assertEqual(response.status_code, 404)

    def test_create_and_get_user(self):
        user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }
        response = self.app.put('/user/user1', data=json.dumps(user_data), content_type='application/json')
        self.assertEqual(response.status_code, 201)

        response = self.app.get('/user/user1')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['id'], 'user1')

    def test_delete_user(self):
        user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }
        self.app.put('/user/user1', data=json.dumps(user_data), content_type='application/json')

        response = self.app.delete('/user/user1')
        self.assertEqual(response.status_code, 204)

        response = self.app.get('/user/user1')
        self.assertEqual(response.status_code, 404)

    def test_discover_videos(self):
        # Create a user first
        user_data = {
            'id': 'user1',
            'username': 'testuser',
            'email': 'testuser@example.com',
            'profile_picture_url': 'path/to/profile_picture'
        }
        self.app.put('/user/user1', data=json.dumps(user_data), content_type='application/json')

        # Create a course and videos
        course_data = {
            'id': 'course1',
            'title': 'Course 1',
            'description': 'A sample course',
            'short_description': 'Sample short description',
            'category': 'Category 1',
            'duration': '10 hours',
            'thumbnail_path': 'path/to/thumbnail',
            'rating': 4.5,
            'istructor_id': 'user1'
        }
        self.app.put('/course/course1', data=json.dumps(course_data), content_type='application/json')

        video_data_1 = {
            'id': 'video1',
            'title': 'Video 1',
            'num_likes': 10,
            'num_views': 100,
            'description': 'A sample video',
            'video_path': 'path/to/video',
            'thumbnail_path': 'path/to/thumbnail',
            'premium': False,
            'course_id': 'course1'
        }
        video_data_2 = {
            'id': 'video2',
            'title': 'Video 2',
            'num_likes': 5,
            'num_views': 50,
            'description': 'Another sample video',
            'video_path': 'path/to/video2',
            'thumbnail_path': 'path/to/thumbnail2',
            'premium': False,
            'course_id': 'course1'
        }
        self.app.put('/video/video1', data=json.dumps(video_data_1), content_type='application/json')
        self.app.put('/video/video2', data=json.dumps(video_data_2), content_type='application/json')

        response = self.app.get('/discover_videos/2')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.json), 2)

if __name__ == '__main__':
    unittest.main()
