from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tiktok_clone.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Define the User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    videos = db.relationship('Video', backref='user', lazy=True)

# Define the Video model
class Video(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(120), nullable=False)
    filename = db.Column(db.String(120), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

# Route to upload a video
@app.route('/upload', methods=['POST'])
def upload_video():
    username = request.form['username']
    title = request.form['title']
    file = request.files['file']
    
    user = User.query.filter_by(username=username).first()
    if not user:
        user = User(username=username)
        db.session.add(user)
        db.session.commit()

    filename = f'{user.id}_{file.filename}'
    file.save(f'uploads/{filename}')
    
    video = Video(title=title, filename=filename, user_id=user.id)
    db.session.add(video)
    db.session.commit()
    
    return jsonify({'message': 'Video uploaded successfully'})

# Route to retrieve videos
@app.route('/videos', methods=['GET'])
def get_videos():
    videos = Video.query.all()
    return jsonify([{'id': video.id, 'title': video.title, 'filename': video.filename, 'user': video.user.username} for video in videos])

# Route to retrieve a specific user's videos
@app.route('/user/<username>/videos', methods=['GET'])
def get_user_videos(username):
    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404
    
    videos = Video.query.filter_by(user_id=user.id).all()
    return jsonify([{'id': video.id, 'title': video.title, 'filename': video.filename} for video in videos])

if __name__ == '__main__':
    app.run(debug=True)
