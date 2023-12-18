package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Localizacao;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class LocalizacaoRepository extends BaseRepository<Localizacao> {

    public List<Localizacao> buscarTodosPorEvento(Long eventoId) {
        return find("FROM Localizacao WHERE evento.id = ?1", eventoId).list();
    }
}
