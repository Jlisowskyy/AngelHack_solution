from sqlalchemy import Column, Integer, String, Float
from database import Base

class Course(Base):
    __tablename__ = 'courses'
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    short_description = Column(String)
    description = Column(String)
    category = Column(String)
    instructor = Column(String)
    duration = Column(String)
    thumbnail_url = Column(String)
    rating = Column(Float)

class Video(Base):
    __tablename__ = 'videos'
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String)
    thumbnail_url = Column(String)
    course_id = Column(Integer, index=True)
    video_url = Column(String)
    num_likes = Column(Integer)
    num_views = Column(Integer)
