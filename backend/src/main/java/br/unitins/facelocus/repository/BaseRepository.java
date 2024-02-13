package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

import java.util.List;

public abstract class BaseRepository<T> implements PanacheRepositoryBase<T, Long> {

    @PersistenceContext
    EntityManager em;

    protected Class<T> entityClass;
    private final String entitySimpleName;

    public BaseRepository(Class<T> entityClass) {
        this.entityClass = entityClass;
        this.entitySimpleName = entityClass.getSimpleName();
    }

    public DataPagination<T> findAll(Pageable pageable) {
        PanacheQuery<T> panacheQuery = findAll();
        return buildDataPagination(pageable, panacheQuery);
    }

    public void deleteEntityById(Long id) {
        Query query = em.createQuery("DELETE FROM " + entitySimpleName + " e WHERE e.id = :id");
        query.setParameter("id", id);
        query.executeUpdate();
    }

    private Pagination buildPaginationFromPageable(Pageable pageable, PanacheQuery<T> panacheQuery) {
        long totalItems = panacheQuery.count();
        long totalPages = totalItems / pageable.getSize();
        return new Pagination(pageable.getPage(), totalPages, totalItems);
    }

    protected DataPagination<T> buildDataPagination(Pageable pageable, PanacheQuery<T> panacheQuery) {
        Pagination pagination = buildPaginationFromPageable(pageable, panacheQuery);
        panacheQuery.page(pageable.getPage(), pageable.getSize());
        List<T> list = panacheQuery.list();
        return new DataPagination<>(list, pagination);
    }

    public boolean existsById(Long id) {
        // language=jpaql
        String query = String.format("FROM %s WHERE id = ?1", entitySimpleName);
        return count(query, id) > 0;
    }
}
