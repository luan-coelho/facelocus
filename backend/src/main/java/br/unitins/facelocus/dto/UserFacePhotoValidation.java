package br.unitins.facelocus.dto;

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

    UserFacePhoto userFacePhoto;
    boolean faceDetected;
}
