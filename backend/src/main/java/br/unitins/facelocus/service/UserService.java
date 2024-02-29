package br.unitins.facelocus.service;

import br.unitins.facelocus.dto.user.ChangePasswordDTO;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.repository.UserRepository;
import br.unitins.facelocus.service.auth.PasswordHandlerService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class UserService extends BaseService<User, UserRepository> {

    @Inject
    PasswordHandlerService passwordHandlerService;

    public List<User> findAllByEventId(Long eventId) {
        return this.repository.findAllByEventId(eventId);
    }

    public List<User> findAllByNameOrCpf(Long userId, String identifier) {
        return this.repository.findAllByNameOrCpf(userId, identifier.trim());
    }

    @Override
    public User findById(Long userId) {
        return super.findByIdOptional(userId)
                .orElseThrow(() -> new NotFoundException("Usuário não encontrado pelo id"));
    }

    public Optional<User> findByEmailOrCpf(String identifier) {
        return this.repository.findByEmailOrCpf(identifier);
    }

    @Transactional
    public User create(User user) {
        if (this.repository.existsByCpf(user.getCpf())) {
            throw new IllegalArgumentException("Usuário já cadastrado com o CPF informado");
        }

        if (this.repository.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Usuário já cadastrado com o email informado");
        }
        user.setCpf(user.getCpf().replaceAll("[^0-9]", ""));
        user.setPassword(passwordHandlerService.passwordHash(user.getPassword()));
        return super.create(user);
    }

    /**
     * Responsável por alterar a senha de um usuário em seu perfil
     *
     * @param userId            Identificador do usuário
     * @param changePasswordDTO Informações sobre as credênciais
     */
    public void changePassword(Long userId, ChangePasswordDTO changePasswordDTO) {
        User user = findById(userId);

        if (!passwordHandlerService.checkPassword(changePasswordDTO.currentPassword(), user.getPassword())) {
            throw new IllegalArgumentException("A senha atual informada está incorreta");
        }
        user.setPassword(passwordHandlerService.passwordHash(changePasswordDTO.confirmPassword()));
        this.update(user);
    }
}
