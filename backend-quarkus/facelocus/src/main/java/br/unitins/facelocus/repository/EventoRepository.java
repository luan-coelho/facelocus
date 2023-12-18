package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Evento;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class EventoRepository extends BaseRepository<Evento> {

    public boolean existePeloCodigo(String codigo) {
        return count("FROM Evento WHERE codigo = ?1", codigo) > 0;
    }
}
