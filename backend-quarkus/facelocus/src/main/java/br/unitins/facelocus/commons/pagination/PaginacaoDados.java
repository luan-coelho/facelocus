package br.unitins.facelocus.commons.pagination;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@Getter
@AllArgsConstructor
public class PaginacaoDados<T> {

    @Setter
    private List<T> dados;
    private Paginacao paginacao = new Paginacao();
}

