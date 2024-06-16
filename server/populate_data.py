import os
from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models

# Ensure all tables are created
models.Base.metadata.create_all(bind=engine)

# Directory where video files are stored
VIDEO_DIR = "videos"

# Get the list of video files
video_files = [f for f in os.listdir(VIDEO_DIR) if f.endswith('.mp4')]

# Sample synthetic data for courses
courses_data = [
    {
        'id': 1,
        'title': 'Introduction to Flutter',
        'short_description': 'Learn the basics of Flutter.',
        'description': "Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. Learn the basics of Flutter for effective mobile development.",
        'category': 'Mobile Development',
        'instructor': 'Jane Adams',
        'duration': '5 hours',
        'thumbnail_url': 'https://i.pinimg.com/736x/af/44/ea/af44ea07fa5bfd828004747f62f63bc3.jpg',
        'rating': 4.5
    },
    {
        'id': 2,
        'title': 'Introduction to React',
        'short_description': 'Learn the basics of React.',
        'description': "React is a JavaScript library for building user interfaces. It's maintained by Facebook and a community of individual developers and companies.",
        'category': 'Web Development',
        'instructor': 'Johny Smith',
        'duration': '3 hours',
        'thumbnail_url': 'https://www.pngitem.com/pimgs/m/146-1468479_react-logo-png-react-js-transparent-png.png',
        'rating': 4.0
    }
]

# Generate synthetic data for videos
videos_data = []
video_id = 101

for idx, video_file in enumerate(video_files):
    video_data = {
        'id': video_id + idx,
        'title': f'Video {idx + 1}',
        'description': f'Description for video {idx + 1}.',
        'thumbnail_url': f'https://example.com/thumbnail_{idx + 1}.jpg',
        'course_id': 1 if idx % 2 == 0 else 2,  # Alternate between course 1 and 2
        'video_url': f'/get_video/{video_file}',  # e.g., '/get_video/video1.mp4
        'num_likes': 100 + 20 * idx,
        'num_views': 1000 + 100 * idx
    }
    videos_data.append(video_data)

def populate_db():
    db: Session = SessionLocal()
    try:
        for course in courses_data:
            db_course = models.Course(**course)
            db.add(db_course)
        
        for video in videos_data:
            db_video = models.Video(**video)
            db.add(db_video)

        db.commit()
    finally:
        db.close()

if __name__ == "__main__":
    # Clean up the database
    db: Session = SessionLocal()
    db.query(models.Video).delete()
    db.query(models.Course).delete()
    db.commit()
    db.close()

    populate_db()
    print("Database populated with synthetic data.")
