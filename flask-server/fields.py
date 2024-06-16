
from flask_restful import Api, Resource, reqparse, abort, fields, marshal_with

video_fields = {
    'id': fields.String,
    'title': fields.String,
    'num_likes': fields.Integer,
    'num_views': fields.Integer,
    'category': fields.String,
    'lesson_number': fields.Integer,
    'description': fields.String,
    'video_path': fields.String,
    'thumbnail_path': fields.String,
    'premium': fields.Boolean,
    'course_id': fields.String
}

video_put_args = reqparse.RequestParser()
video_put_args.add_argument("id", type=str, help="Id of the video is required", required=True)
video_put_args.add_argument("title", type=str, help="Title of the video is required", required=True)
video_put_args.add_argument("num_likes", type=int, help="Number of likes on the video", required=True)
video_put_args.add_argument("num_views", type=int, help="Number of views on the video", required=True)
video_put_args.add_argument("category", type=str, help="Category of the video", required=True)
video_put_args.add_argument("lesson_number", type=int, help="Lesson number of the video", required=True)
video_put_args.add_argument("description", type=str, help="Description of the video", required=True)
video_put_args.add_argument("video_path", type=str, help="Path to the video", required=True)
video_put_args.add_argument("thumbnail_path", type=str, help="Path to the thumbnail", required=True)
video_put_args.add_argument("premium", type=bool, help="Premium status of the video", required=True)
video_put_args.add_argument("course_id", type=str, help="Course id of the video", required=True)



course_fields = {
    'id': fields.String,
    'title': fields.String,
    'description': fields.String,
    'short_description': fields.String,
    'category': fields.String,
    'istructor_id': fields.String,
    'duration': fields.String,
    'thumbnail_path': fields.String,
    'rating': fields.Float
}


course_put_args = reqparse.RequestParser()

course_put_args.add_argument("id", type=str, help="Id of the course is required", required=True)
course_put_args.add_argument("title", type=str, help="Title of the course is required", required=True)
course_put_args.add_argument("description", type=str, help="Description of the course", required=True)
course_put_args.add_argument("short_description", type=str, help="Short description of the course", required=True)
course_put_args.add_argument("category", type=str, help="Category of the course", required=True)
course_put_args.add_argument("istructor_id", type=str, help="Instructor of the course", required=True)
course_put_args.add_argument("duration", type=str, help="Duration of the course", required=True)
course_put_args.add_argument("thumbnail_path", type=str, help="Path to the thumbnail", required=True)
course_put_args.add_argument("rating", type=float, help="Rating of the course", required=True)


user_fields = {
    'id': fields.String,
    'token_address': fields.String,
    'username': fields.String,
    'email': fields.String,
    'preferences': fields.String,
    'profile_picture_url': fields.String
}

user_put_args = reqparse.RequestParser()
user_put_args.add_argument("id", type=str, help="Id of the user is required", required=True)
user_put_args.add_argument("token_address", type=str, help="Token address of the user is required", required=True)
user_put_args.add_argument("username", type=str, help="Username of the user is required", required=True)
user_put_args.add_argument("email", type=str, help="Email of the user is required", required=True)
user_put_args.add_argument("preferences", type=str, help="Preferences of the user", required=True)
user_put_args.add_argument("profile_picture_url", type=str, help="Profile picture of the user is required", required=True)

