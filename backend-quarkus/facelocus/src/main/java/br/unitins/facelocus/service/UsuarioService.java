package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.PaginacaoDados;
import br.unitins.facelocus.commons.pagination.Paginavel;
import br.unitins.facelocus.model.Usuario;
import br.unitins.facelocus.repository.UsuarioRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

@ApplicationScoped
public class UsuarioService extends BaseService<Usuario, UsuarioRepository> {

    @Inject
    FotoRostoUsuarioService fotoRostoUsuarioService;

    public PaginacaoDados<Usuario> buscarTodos(Paginavel paginavel) {
        return this.buscarTodosPaginados(paginavel);
    }

    @Transactional
    public Usuario criar(Usuario usuario) {
        if (this.repository.existePeloCpf(usuario.getCpf())) {
            throw new IllegalArgumentException("Usuário já cadastrado com o CPF informado");
        }

        if (this.repository.existePeloEmail(usuario.getEmail())) {
            throw new IllegalArgumentException("Usuário já cadastrado com o email informado");
        }
        return super.criar(usuario);
    }
}
