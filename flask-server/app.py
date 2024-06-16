from flask import Flask, request, jsonify
from flask_restful import Api, Resource, reqparse, abort, fields, marshal_with
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

from fields import video_fields, video_put_args, course_fields, course_put_args, user_fields, user_put_args
import logging

logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)


app = Flask(__name__)
CORS(app)
api = Api(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
db = SQLAlchemy(app)

class VideoModel(db.Model):
    __tablename__ = 'video'
    id = db.Column(db.String(100), primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    num_likes = db.Column(db.Integer, nullable=False)
    num_views = db.Column(db.Integer, nullable=False)
    category = db.Column(db.String(100), nullable=False) # TODO: dodaj wszedzie gdzie trzeba zmienic ehhe
    lesson_number = db.Column(db.Integer, nullable=False)
    tags = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(100), nullable=False)
    video_path = db.Column(db.String(100), nullable=False)
    thumbnail_path = db.Column(db.String(100), nullable=False)
    premium = db.Column(db.Boolean, nullable=False)
    course_id = db.Column(db.String(100), db.ForeignKey('course.id'), nullable=False)
    
   
    def __repr__(self):
        return f"Video(title = {title}, num_likes = {num_likes}, num_views = {num_views}, description = {description}, video_path = {video_path}, thumbnail_path = {thumbnail_path}, premium = {premium}, course_id = {course_id})"

class CourseModel(db.Model):
    __tablename__ = 'course'
    id = db.Column(db.String(100), primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(100), nullable=False)
    short_description = db.Column(db.String(100), nullable=False)
    category = db.Column(db.String(100), nullable=False)
    duration = db.Column(db.String(100), nullable=False)
    thumbnail_path = db.Column(db.String(100), nullable=False)
    rating = db.Column(db.Float, nullable=False)
    istructor_id = db.Column(db.String(100), db.ForeignKey('user.id'), nullable=False)
    

    def __repr__(self):
        return f"Course(title = {title}, description = {description}, short_description = {short_description}, category = {category}, duration = {duration}, thumbnail_path = {thumbnail_path}, rating = {rating}, istructor_id = {istructor_id})"

    
class UserModel(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.String(100), primary_key=True)
    token_address = db.Column(db.String(100), nullable=False)
    username = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    preferences = db.Column(db.String(100), nullable=False)
    profile_picture_url = db.Column(db.String(100), nullable=False)

    def __repr__(self):
        return f"User(username = {username}, email = {email}, profile_picture_url = {profile_picture_url})"


    
class CourseVideoModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    course_id = db.Column(db.String(100), db.ForeignKey('course.id'), nullable=False)
    video_id = db.Column(db.String(100), db.ForeignKey('video.id'), nullable=False)
    
    def __repr__(self):
        return f"CourseVideo(course_id = {course_id}, video_id = {video_id})"

class UserCourseModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(100), db.ForeignKey('user.id'), nullable=False)
    course_id = db.Column(db.String(100), db.ForeignKey('course.id'), nullable=False)
    
    def __repr__(self):
        return f"UserCourse(user_id = {user_id}, course_id = {course_id})"
    
class InstructorCourseModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    instructor_id = db.Column(db.String(100), db.ForeignKey('user.id'), nullable=False)
    course_id = db.Column(db.String(100), db.ForeignKey('course.id'), nullable=False)
    
    def __repr__(self):
        return f"InstructorCourse(instructor_id = {instructor_id}, course_id = {course_id})"
    


class Video(Resource):
    @marshal_with(video_fields)
    def get(self, video_id):
        video = VideoModel.query.filter_by(id=video_id).first()
        if not video:
            abort(404, message="Could not find video with that id")
        return video
    
    @marshal_with(video_fields)
    def put(self, video_id):
        args = video_put_args.parse_args()
        video = VideoModel.query.filter_by(id=args['id']).first()
        if video:
            abort(409, message="Video id taken...")
        video = VideoModel(id=args['id'], title=args['title'], num_likes=args['num_likes'], num_views=args['num_views'], description=args['description'], video_path=args['video_path'], thumbnail_path=args['thumbnail_path'], course_id=args['course_id'])
        course_video = CourseVideoModel(course_id=args['course_id'], video_id=args['id'])
        db.session.add(video)
        db.session.add(course_video)
        db.session.commit()
        return video, 201

    def delete(self, video_id):
        video = VideoModel.query.filter_by(id=video_id).first()
        course_video = CourseVideoModel.query.filter_by(video_id=video_id).first()

        db.session.delete(video)
        db.session.delete(course_video)
        db.session.commit()
        return '', 204
    




class Course(Resource):
    @marshal_with(course_fields)
    def get(self, course_id):

        course = CourseModel.query.filter_by(id=course_id).first()
        if not course:
            abort(404, message="Could not find course with that id")
        return course
    
    @marshal_with(course_fields)
    def put(self, course_id):
        args = course_put_args.parse_args()
        course = CourseModel.query.filter_by(id=course_id).first()
        if course:
            abort(409, message="Course id taken...")
        course = CourseModel(id=args['id'], title=args['title'], description=args['description'], thumbnail_path=args['thumbnail_path'])
        instructor_course = InstructorCourseModel(instructor_id=args['istructor_id'], course_id=args['id'])
        db.session.add(course)
        db.session.add(instructor_course)
        db.session.commit()
        return course, 201

    def delete(self, course_id):
        course = CourseModel.query.filter_by(id=course_id).first()
        # get all videos associated with the course
        course_videos = CourseVideoModel.query.filter_by(course_id=course_id).all()
        # get all users enrolled in the course
        user_courses = UserCourseModel.query.filter_by(course_id=course_id).all()
        # delete all videos associated with the course
        for course_video in course_videos:
            video = VideoModel.query.filter_by(id=course_video.video_id).first()
            db.session.delete(video)
            db.session.delete(course_video)
        
        # delete connection from user to course
        for user_course in user_courses:
            db.session.delete(user_course)

        # delete course
        instructor_course = InstructorCourseModel.query.filter_by(course_id=course_id).first()
        db.session.delete(instructor_course)
        
        db.session.delete(course)
        db.session.commit()
        return '', 204

class User(Resource):
    @marshal_with(user_fields)
    def get(self, user_id):
        user = UserModel.query.filter_by(id=user_id).first()
        if not user:
            abort(404, message="Could not find user with that id")
        return user
    
    @marshal_with(course_fields)
    def put(self, user_id):
        args = user_put_args.parse_args()
        user = UserModel.query.filter_by(id=user_id).first()
        if user:
            abort(409, message="User id taken...")
        user = UserModel(id=args['id'], token_address=args['token_address'], username=args['username'], email=args['email'], preferences=args['preferences'], profile_picture_url=args['profile_picture_url'])
        db.session.add(user)
        db.session.commit()
        return user, 201

    def delete(self, user_id):
        user = UserModel.query.filter_by(id=user_id).first()
        # get all courses associated with the user
        user_courses = UserCourseModel.query.filter_by(user_id=user_id).all()
        # get all courses taught by the user
        instructor_courses = InstructorCourseModel.query.filter_by(instructor_id=user_id).all()
        # delete all courses associated with the user
        for user_course in user_courses:
            db.session.delete(user_course)
        
        # delete all courses taught by the user
        for instructor_course in instructor_courses:
            course = CourseModel.query.filter_by(id=instructor_course.course_id).first()
            db.session.delete(course)
            db.session.delete(instructor_course)
        
        db.session.delete(user)
        db.session.commit()
        return '', 204
    

class DiscoverVideos(Resource):
    @marshal_with(video_fields)
    def get(self, video_num):
        videos = VideoModel.query.filter_by(premium=False).limit(video_num).all()

        return videos

class CourseVideos(Resource):
    @marshal_with(video_fields)
    def get(self, course_id):
        course_videos = CourseVideoModel.query.filter_by(course_id=course_id).all()
        videos = []
        for course_video in course_videos:
            video = VideoModel.query.filter_by(id=course_video.video_id).first()
            videos.append(video)
        return videos

class CourseSearch(Resource):
    @marshal_with(course_fields)
    def get(self, search_query):
        args = course_put_args.parse_args()
        name_pattern = f"%{args['name']}%"
        courses = CourseModel.query.filter(CourseModel.title.ilike(name_pattern)).all()
        #courses = CourseModel.query.filter_by(category=search_query).all()
        return courses
    
api.add_resource(DiscoverVideos, '/discover_videos/<int:video_num>')
api.add_resource(Video, '/video/<string:video_id>')
api.add_resource(Course, '/course/<string:course_id>')
api.add_resource(User, '/user/<string:user_id>')


@app.errorhandler(500)
def handle_500_error(e):
    """Handle 500 errors by shutting down the server."""
    shutdown_server()
    return jsonify(error=str(e)), 500

def shutdown_server():
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()



def create_tables():
    db.create_all()
    print("All tables created.")


if __name__ == '__main__':
    with app.app_context():
        
        app.run(debug=True)
        create_tables()