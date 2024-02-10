package br.unitins.facelocus.commons.pagination;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class DataPagination<T> {

    private List<T> data;
    private Pagination pagination = new Pagination();
}

