package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Usuario;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class UsuarioRepository extends BaseRepository<Usuario> {

    public boolean existePeloCpf(String cpf) {
        return count("FROM Usuario WHERE cpf = ?1", cpf) > 0;
    }

    public boolean existePeloEmail(String email){
        return count("FROM Usuario WHERE email = ?1", email) > 0;
    }
}
