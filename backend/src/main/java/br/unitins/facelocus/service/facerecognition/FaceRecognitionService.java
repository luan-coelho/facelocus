package br.unitins.facelocus.service.facerecognition;

public interface FaceRecognitionService {

    boolean faceDetected(String photoFacePath, String profilePhotoFacePath);
}
