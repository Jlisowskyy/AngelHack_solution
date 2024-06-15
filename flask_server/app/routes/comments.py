from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models import Comment, Video, User
from app import db

bp = Blueprint('comments', __name__, url_prefix='/comments')

@bp.route('/add', methods=['POST'])
@jwt_required()
def add_comment():
    user_id = get_jwt_identity()
    data = request.get_json()
    video_id = data.get('video_id')
    content = data.get('content')

    comment = Comment(content=content, video_id=video_id, user_id=user_id)
    db.session.add(comment)
    db.session.commit()

    return jsonify({'message': 'Comment added successfully'}), 201

@bp.route('/<int:video_id>', methods=['GET'])
def get_comments(video_id):
    comments = Comment.query.filter_by(video_id=video_id).all()
    return jsonify([comment.to_dict() for comment in comments])
