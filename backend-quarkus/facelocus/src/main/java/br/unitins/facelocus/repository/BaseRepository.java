package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;

public abstract class BaseRepository<T> implements PanacheRepositoryBase<T, Long> {

    public Pagination buildPagination(Pageable pageable) {
        long numberOfRecords = count();
        long totalPages = numberOfRecords / pageable.getSize();
        return new Pagination(pageable.getPage(), totalPages, numberOfRecords);
    }
}
