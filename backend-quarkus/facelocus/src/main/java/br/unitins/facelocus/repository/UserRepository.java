package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.User;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.Optional;

@ApplicationScoped
public class UserRepository extends BaseRepository<User> {

    public boolean existsByCpf(String cpf) {
        return count("FROM User WHERE cpf = ?1", cpf) > 0;
    }

    public boolean existsByEmail(String email) {
        return count("FROM User WHERE email = ?1", email) > 0;
    }

    public Optional<User> findByCredentials(String email, String senha) {
        return find("FROM User WHERE email = ?1 AND password = ?2", email, senha).firstResultOptional();
    }
}
