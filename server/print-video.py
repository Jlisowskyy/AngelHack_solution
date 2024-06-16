from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models

# Ensure all tables are created
models.Base.metadata.create_all(bind=engine)

def get_all_videos():
    db: Session = SessionLocal()
    try:
        videos = db.query(models.Video).all()
        return videos
    finally:
        db.close()

def print_videos(videos):
    for video in videos:
        print(f"ID: {video.id}")
        print(f"Title: {video.title}")
        print(f"Description: {video.description}")
        print(f"Thumbnail URL: {video.thumbnail_url}")
        print(f"Course ID: {video.course_id}")
        print(f"Video URL: {video.video_url}")
        print(f"Number of Likes: {video.num_likes}")
        print(f"Number of Views: {video.num_views}")
        print("-" * 20)

if __name__ == "__main__":
    videos = get_all_videos()
    print_videos(videos)
