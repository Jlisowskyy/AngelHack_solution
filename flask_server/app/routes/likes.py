from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models import Like, Video, User
from app import db

bp = Blueprint('likes', __name__, url_prefix='/likes')

@bp.route('/like', methods=['POST'])
@jwt_required()
def like_video():
    user_id = get_jwt_identity()
    data = request.get_json()
    video_id = data.get('video_id')

    if Like.query.filter_by(user_id=user_id, video_id=video_id).first():
        return jsonify({'error': 'Video already liked'}), 400

    like = Like(user_id=user_id, video_id=video_id)
    db.session.add(like)
    db.session.commit()

    return jsonify({'message': 'Video liked successfully'}), 201

@bp.route('/unlike', methods=['POST'])
@jwt_required()
def unlike_video():
    user_id = get_jwt_identity()
    data = request.get_json()
    video_id = data.get('video_id')

    like = Like.query.filter_by(user_id=user_id, video_id=video_id).first()
    if not like:
        return jsonify({'error': 'Video not liked yet'}), 400

    db.session.delete(like)
    db.session.commit()

    return jsonify({'message': 'Video unliked successfully'}), 200
