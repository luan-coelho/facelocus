package br.unitins.facelocus.dto.webservice;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class ServiceResult {

    private boolean faceDetected;
    private float executionTime;
}
