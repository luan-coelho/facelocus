from flask import Flask

from app.features.face_services.views import face_services_bp
from app.features.deepface.views import deepface_bp
from app.features.facerecognition.views import facerecognition_bp
from app.features.insightface.views import insightface_bp
from error_handlers import register_error_handlers

app = Flask(__name__)

register_error_handlers(app)

app.register_blueprint(face_services_bp)
app.register_blueprint(facerecognition_bp)
app.register_blueprint(deepface_bp)
app.register_blueprint(insightface_bp)

if __name__ == '__main__':
    app.run(debug=False)
