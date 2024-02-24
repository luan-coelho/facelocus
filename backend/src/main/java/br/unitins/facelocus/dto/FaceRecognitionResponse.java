package br.unitins.facelocus.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class FaceRecognitionResponse {

    private boolean faceDetected;
    private String error;
}