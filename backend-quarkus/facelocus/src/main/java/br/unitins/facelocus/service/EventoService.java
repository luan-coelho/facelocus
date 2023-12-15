package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.PaginacaoDados;
import br.unitins.facelocus.commons.pagination.Paginavel;
import br.unitins.facelocus.model.Evento;
import br.unitins.facelocus.repository.EventoRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class EventoService extends BaseService<Evento, EventoRepository>{

    public PaginacaoDados<Evento> buscarTodos(Paginavel paginavel) {
        return this.buscarTodosPaginados(paginavel);
    }
}
