package br.unitins.facelocus.exception;

import lombok.*;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class ErrorResponse {

    private URI type;
    private String title;
    private int status;
    private Object detail;
    private URI instance;
}