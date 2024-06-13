package br.unitins.facelocus.commons.pagination;

import jakarta.ws.rs.QueryParam;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Pageable {

    @QueryParam("page")
    private int page = 0;
    @QueryParam("size")
    private int size = Pagination.STANDARD_PAGE_SIZE;
    @QueryParam("sort")
    private String sort;

}
