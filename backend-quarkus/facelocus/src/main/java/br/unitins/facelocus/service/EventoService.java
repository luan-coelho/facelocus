package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.PaginacaoDados;
import br.unitins.facelocus.commons.pagination.Paginavel;
import br.unitins.facelocus.model.Evento;
import br.unitins.facelocus.model.Localizacao;
import br.unitins.facelocus.repository.EventoRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.security.SecureRandom;
import java.util.List;

@ApplicationScoped
public class EventoService extends BaseService<Evento, EventoRepository> {

    @Inject
    LocalizacaoService localizacaoService;

    /**
     * Busca todos os eventos de maneira paginada, juntamente com seus relacionamentos.
     *
     * @param paginavel contem informacoes de paginacao
     * @return lista paginada
     */
    public PaginacaoDados<Evento> buscarTodosPaginados(Paginavel paginavel) {
        List<Evento> eventos = repository.listAll();
        for (Evento evento : eventos) {
            List<Localizacao> localizacoes = localizacaoService.buscarTodosPorEvento(evento);
            evento.setLocalizacoes(localizacoes);
        }
        return construirPaginacaoDeDados(eventos, paginavel);
    }

    @Transactional
    @Override
    public Evento criar(Evento evento) {
        if (evento.isPermitirSolicitacoesIngresso()) {
            evento.setCodigo(gerarCodigoUnico());
        }
        for (Localizacao localizacao : evento.getLocalizacoes()) {
            localizacao.setEvento(evento);
        }
        return super.criar(evento);
    }

    public String gerarCodigoUnico() {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        int tamanhoCodigo = 6;
        SecureRandom random = new SecureRandom();
        StringBuilder codigo = new StringBuilder(tamanhoCodigo);

        for (int i = 0; i < tamanhoCodigo; i++) {
            int indice = random.nextInt(caracteres.length());
            codigo.append(caracteres.charAt(indice));
        }

        if (this.repository.existePeloCodigo(codigo.toString())) {
            codigo = new StringBuilder(gerarCodigoUnico());
            return codigo.toString();
        }
        return codigo.toString();
    }
}
