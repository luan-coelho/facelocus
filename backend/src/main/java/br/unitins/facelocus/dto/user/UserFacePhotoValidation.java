package br.unitins.facelocus.dto.user;

import br.unitins.facelocus.model.UserFacePhoto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserFacePhotoValidation {

    private UserFacePhoto userFacePhoto;
    private boolean faceDetected;
    private String errorMessage;
}
