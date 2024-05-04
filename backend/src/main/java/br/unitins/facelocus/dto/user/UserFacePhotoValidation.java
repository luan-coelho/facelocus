package br.unitins.facelocus.dto.user;

import br.unitins.facelocus.dto.webservice.FaceRecognitionAllServices;
import br.unitins.facelocus.model.FacePhoto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserFacePhotoValidation {

    private FacePhoto facePhoto;
    private boolean faceDetected;
    private String errorMessage;

    private FaceRecognitionAllServices recognitionResult;
}
