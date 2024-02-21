package br.unitins.facelocus.exception;

import java.net.URI;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

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