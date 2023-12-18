package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.repository.UserRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;

@ApplicationScoped
public class UserService extends BaseService<User, UserRepository> {

    public DataPagination<User> findAll(Pageable pageable) {
        return this.findAllPaginated(pageable);
    }

    @Transactional
    public User create(User user) {
        if (this.repository.existsByCpf(user.getCpf())) {
            throw new IllegalArgumentException("Usuário já cadastrado com o CPF informado");
        }

        if (this.repository.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Usuário já cadastrado com o email informado");
        }
        return super.create(user);
    }
}
