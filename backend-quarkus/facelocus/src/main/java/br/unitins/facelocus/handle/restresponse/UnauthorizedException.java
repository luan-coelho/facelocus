package br.unitins.facelocus.handle.restresponse;

public class UnauthorizedException extends AuthenticationException {

    public UnauthorizedException(String message) {
        super(message);
    }
}
