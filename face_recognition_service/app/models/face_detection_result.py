class FaceDetectionResult:
    def __init__(self, face_detected, execution_time):
        self.face_detected = face_detected
        self.execution_time = execution_time

    def to_dict(self):
        return {
            'faceDetected': self.face_detected,
            'executionTime': self.execution_time
        }
