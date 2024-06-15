from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from routes import auth, videos, comments, likes
#from errors import bp as errors_bp

print("Creating app and db")
db = SQLAlchemy()
migrate = Migrate()

def create_app():
    print("create_app function called")
    app = Flask(__name__)
    app.config.from_object('config.Config')



    db.init_app(app)
    migrate.init_app(app, db)
    CORS(app)
    JWTManager(app)  # Setup JWT

    #from .routes import auth, videos, comments, likes
    app.register_blueprint(auth.bp)
    app.register_blueprint(videos.bp)
    app.register_blueprint(comments.bp)
    app.register_blueprint(likes.bp)

    #from .errors import bp as errors_bp
    #app.register_blueprint(errors_bp)

    return app
