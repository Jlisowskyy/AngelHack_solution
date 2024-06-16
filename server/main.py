from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import crud
import models
import schemas
from database import SessionLocal, engine, get_db
from fastapi.responses import FileResponse
import os

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# Configure CORS
origins = [
    "http://localhost",
    "http://localhost:8080",
    "http://localhost:3000",
    "http://localhost:4200",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

VIDEO_DIR = "videos"

@app.get("/get_video/{video_filename}")
async def get_video(video_filename: str):
    video_path = os.path.join(VIDEO_DIR, video_filename)
    if os.path.exists(video_path):
        return FileResponse(video_path)
    else:
        raise HTTPException(status_code=404, detail="Video not found")

@app.post("/courses/", response_model=schemas.Course)
def create_course(course: schemas.CourseCreate, db: Session = Depends(get_db)):
    return crud.create_course(db=db, course=course)

@app.get("/courses/", response_model=list[schemas.Course])
def read_courses(keyword: str = None, limit: int = 100, db: Session = Depends(get_db)):
    courses = crud.get_courses(db, keyword=keyword, limit=limit)
    return courses

@app.get("/courses/{course_id}", response_model=schemas.Course)
def read_course(course_id: int, db: Session = Depends(get_db)):
    db_course = crud.get_course(db, course_id=course_id)
    if db_course is None:
        raise HTTPException(status_code=404, detail="Course not found")
    return db_course

@app.post("/videos/", response_model=schemas.Video)
def create_video(video: schemas.VideoCreate, db: Session = Depends(get_db)):
    return crud.create_video(db=db, video=video)

@app.get("/videos/{video_id}", response_model=schemas.Video)
def read_video(video_id: int, db: Session = Depends(get_db)):
    db_video = crud.get_video(db, video_id=video_id)
    if db_video is None:
        raise HTTPException(status_code=404, detail="Video not found")
    return db_video

@app.get("/videos/", response_model=list[schemas.Video])
def read_videos(course_id: int = None, db: Session = Depends(get_db)):
    if course_id:
        videos = crud.get_videos_by_course(db, course_id=course_id)
    else:
        videos = db.query(models.Video).all()  # Retrieve all videos if no course_id is specified
    return videos
