package br.unitins.facelocus.service;

import br.unitins.facelocus.dto.ChangePasswordDTO;
import br.unitins.facelocus.model.User;
import br.unitins.facelocus.repository.UserRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

@ApplicationScoped
public class UserService extends BaseService<User, UserRepository> {

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

    /**
     * Responsável por alterar a senha de um usuário em seu perfil
     *
     * @param userId            Identificador do usuário
     * @param changePasswordDTO Informações sobre as credênciais
     */
    public void changePassword(Long userId, ChangePasswordDTO changePasswordDTO) {
        User user = findByIdOptional(userId)
                .orElseThrow(() -> new NotFoundException("Usuário não encontrado pelo id"));

        if (!user.getPassword().equals(changePasswordDTO.currentPassword())) {
            throw new IllegalArgumentException("A senha atual informada está incorreta");
        }
        user.setPassword(changePasswordDTO.confirmPassword());
        this.update(user);
    }
}
