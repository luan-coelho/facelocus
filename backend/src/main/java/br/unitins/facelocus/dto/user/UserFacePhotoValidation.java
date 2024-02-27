package br.unitins.facelocus.dto.user;

import br.unitins.facelocus.model.FacePhoto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserFacePhotoValidation {

    private FacePhoto facePhoto;
    private boolean faceDetected;
    private String errorMessage;
}
