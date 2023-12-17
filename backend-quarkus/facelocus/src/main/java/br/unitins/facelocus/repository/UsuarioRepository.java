package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Usuario;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.Optional;

@ApplicationScoped
public class UsuarioRepository extends BaseRepository<Usuario> {

    public boolean existePeloCpf(String cpf) {
        return count("FROM Usuario WHERE cpf = ?1", cpf) > 0;
    }

    public boolean existePeloEmail(String email) {
        return count("FROM Usuario WHERE email = ?1", email) > 0;
    }

    public Optional<Usuario> buscarPorCredenciais(String email, String senha) {
        return find("FROM Usuario WHERE email = ?1 AND senha = ?2", email, senha).firstResultOptional();
    }
}
