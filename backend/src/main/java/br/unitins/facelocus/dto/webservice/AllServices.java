package br.unitins.facelocus.dto.webservice;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class AllServices {

    private ServiceResult faceRecognition;
    private ServiceResult deepface;
    private ServiceResult insightface;
    private String error;
}