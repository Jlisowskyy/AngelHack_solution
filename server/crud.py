from sqlalchemy.orm import Session
import models
import schemas

def get_course(db: Session, course_id: int):
    return db.query(models.Course).filter(models.Course.id == course_id).first()

def get_courses(db: Session, keyword: str = None, limit: int = 100):
    if keyword:
        return db.query(models.Course).filter(models.Course.title.contains(keyword)).limit(limit).all()
    return db.query(models.Course).limit(limit).all()

def get_video(db: Session, video_id: int):
    return db.query(models.Video).filter(models.Video.id == video_id).first()

def get_videos_by_course(db: Session, course_id: int):
    return db.query(models.Video).filter(models.Video.course_id == course_id).all()

def create_course(db: Session, course: schemas.CourseCreate):
    db_course = models.Course(**course.dict())
    db.add(db_course)
    db.commit()
    db.refresh(db_course)
    return db_course

def create_video(db: Session, video: schemas.VideoCreate):
    db_video = models.Video(**video.dict())
    db.add(db_video)
    db.commit()
    db.refresh(db_video)
    return db_video
