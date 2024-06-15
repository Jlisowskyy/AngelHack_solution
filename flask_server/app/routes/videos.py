from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models import Video, User
from app import db

bp = Blueprint('videos', __name__, url_prefix='/videos')

@bp.route('/upload', methods=['POST'])
@jwt_required()
def upload_video():
    user_id = get_jwt_identity()
    data = request.get_json()
    title = data.get('title')
    description = data.get('description')
    video_url = data.get('video_url')

    video = Video(title=title, description=description, video_url=video_url, user_id=user_id)
    db.session.add(video)
    db.session.commit()

    return jsonify({'message': 'Video uploaded successfully'}), 201

@bp.route('/', methods=['GET'])
def get_videos():
    videos = Video.query.all()
    return jsonify([video.to_dict() for video in videos])
