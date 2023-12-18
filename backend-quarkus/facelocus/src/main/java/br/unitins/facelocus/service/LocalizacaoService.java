package br.unitins.facelocus.service;

import br.unitins.facelocus.model.Evento;
import br.unitins.facelocus.model.Localizacao;
import br.unitins.facelocus.repository.LocalizacaoRepository;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class LocalizacaoService extends BaseService<Localizacao, LocalizacaoRepository> {

    public List<Localizacao> buscarTodosPorEvento(Evento evento) {
        return this.repository.buscarTodosPorEvento(evento.getId());
    }
}
