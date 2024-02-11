package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.User;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class UserRepository extends BaseRepository<User> {

    public UserRepository() {
        super(User.class);
    }

    public boolean existsByCpf(String cpf) {
        return count("FROM User WHERE cpf = ?1", cpf) > 0;
    }

    public boolean existsByEmail(String email) {
        return count("FROM User WHERE email = ?1", email) > 0;
    }

    public List<User> findAllByEventId(Long eventId) {
        return find("SELECT u FROM User u JOIN u.events e WHERE e.id = ?1", eventId).list();
    }

    public List<User> findAllByNameOrCpf(Long userId, String identifier) {
        String sql = """
                FROM User
                WHERE id <> ?1
                    AND
                        (FUNCTION('unaccent',LOWER(name)) || ' ' ||
                        FUNCTION('unaccent', LOWER(surname)) LIKE '%'||?2||'%'
                    OR LOWER(cpf) LIKE '%'||?2||'%')
                """;
        return find(sql, userId, identifier).list();
    }

    public Optional<User> findByEmailOrCpf(String identifier) {
        String sql = """
                FROM User
                WHERE
                    FUNCTION('unaccent',LOWER(email)) LIKE '%'||?1||'%'
                    OR LOWER(cpf) LIKE '%'||?1||'%'
                """;
        return find(sql, identifier).singleResultOptional();
    }
}
