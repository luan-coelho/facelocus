package br.unitins.facelocus.commons.pagination;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Paginacao {

    private int paginaAtual;
    private int itemsPorPagina = TAMANHO_PADRAO_PAGINACAO;
    private long totalPaginas;
    private long totalItems;

    public static final int TAMANHO_PADRAO_PAGINACAO = 25;

    public Paginacao(int paginaAtual, long totalPaginas, long totalItems) {
        this.paginaAtual = paginaAtual;
        this.totalPaginas = totalPaginas;
        this.totalItems = totalItems;
    }
}
