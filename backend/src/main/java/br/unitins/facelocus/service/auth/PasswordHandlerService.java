package br.unitins.facelocus.service.auth;

import jakarta.enterprise.context.ApplicationScoped;
import org.mindrot.jbcrypt.BCrypt;

@ApplicationScoped
public class PasswordHandlerService {

    public String passwordHash(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    public boolean checkPassword(String plainTextPassword, String passwordHash) {
        return BCrypt.checkpw(plainTextPassword, passwordHash);
    }

    public String plainTextPassword(String passwordHash) {
        return BCrypt.gensalt();
    }
}
