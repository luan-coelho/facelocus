from flask import Flask

from app.deepface.views import deepface_bp
from app.insightface.views import insightface_bp
from app.facerecognition.views import facerecognition_bp
from error_handlers import register_error_handlers

app = Flask(__name__)

register_error_handlers(app)

app.register_blueprint(facerecognition_bp)
app.register_blueprint(deepface_bp)
app.register_blueprint(insightface_bp)

if __name__ == '__main__':
    app.run(debug=False)
