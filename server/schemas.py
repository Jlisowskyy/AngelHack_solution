from pydantic import BaseModel

class CourseBase(BaseModel):
    title: str
    short_description: str
    description: str
    category: str
    instructor: str
    duration: str
    thumbnail_url: str
    rating: float

class CourseCreate(CourseBase):
    pass

class Course(CourseBase):
    id: int

    class Config:
        orm_mode: True

class VideoBase(BaseModel):
    title: str
    description: str
    thumbnail_url: str
    course_id: int
    video_url: str
    num_likes: int
    num_views: int

class VideoCreate(VideoBase):
    pass

class Video(VideoBase):
    id: int

    class Config:
        orm_mode: True
