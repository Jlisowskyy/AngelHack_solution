from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///example.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class VideoModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    num_likes = db.Column(db.Integer, nullable=False)
    num_views = db.Column(db.Integer, nullable=False)
    description = db.Column(db.String(100), nullable=False)
    video_path = db.Column(db.String(100), nullable=False)
    thumbnail_path = db.Column(db.String(100), nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey('course_model.id'), nullable=False)
   
    def __repr__(self):
        return (f"Video(title = {self.title}, num_likes = {self.num_likes}, "
                f"num_views = {self.num_views}, description = {self.description}, "
                f"video_path = {self.video_path}, thumbnail_path = {self.thumbnail_path}, "
                f"course_id = {self.course_id})")

class CourseModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(100), nullable=False)
    thumbnail_path = db.Column(db.String(100), nullable=False)
    
    
    def __repr__(self):
        return (f"Course(title = {self.title}, description = {self.description}, "
                f"thumbnail_path = {self.thumbnail_path})")


def create_tables():
    db.create_all()

def add_data():
    course1 = CourseModel(id="as", title='Python Programming', description='Learn Python from scratch.', thumbnail_path='path/to/thumbnail1')
    course2 = CourseModel(title='Data Science', description='Learn Data Science with real-world projects.', thumbnail_path='path/to/thumbnail2')
    
    video1 = VideoModel(title='Introduction to Python', num_likes=100, num_views=1000, description='An introduction to Python programming.', video_path='path/to/video1', thumbnail_path='path/to/thumbnail1', course=course1)
    video2 = VideoModel(title='Python Data Structures', num_likes=150, num_views=1200, description='Learn about Python data structures.', video_path='path/to/video2', thumbnail_path='path/to/thumbnail2', course=course1)
    video3 = VideoModel(title='Data Science Basics', num_likes=200, num_views=1500, description='An introduction to Data Science.', video_path='path/to/video3', thumbnail_path='path/to/thumbnail3', course=course2)
    
    db.session.add(course1)
    db.session.add(course2)
    db.session.add(video1)
    db.session.add(video2)
    db.session.add(video3)
    
    db.session.commit()

if __name__ == '__main__':
    with app.app_context():
        #create_tables()
        #add_data()
        course = CourseModel.query.first()
        for video in course.videos:
            print(video.title)

        print('Data added to the database!')
