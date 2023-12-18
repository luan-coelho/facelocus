package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;

import java.lang.reflect.ParameterizedType;

@SuppressWarnings("unchecked")
public abstract class BaseRepository<T> implements PanacheRepositoryBase<T, Long> {

    public Pagination buildPagination(Pageable pageable) {
        long numberOfRecords = count();
        long totalPages = numberOfRecords / pageable.getSize();
        return new Pagination(pageable.getPage(), totalPages, numberOfRecords);
    }

    public Class<?> getGenericType() {
        return (Class<T>) ((ParameterizedType) getClass()
                .getGenericSuperclass()).getActualTypeArguments()[0];
    }

    public boolean existsById(Long id) {
        String clazz = getGenericType().getSimpleName();
        String query = String.format("FROM %s WHERE id = ?1", clazz);
        return count(query, id) > 0;
    }
}
