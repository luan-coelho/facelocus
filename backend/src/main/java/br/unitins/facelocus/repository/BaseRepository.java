package br.unitins.facelocus.repository;

import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.transaction.Transactional;

public abstract class BaseRepository<T> implements PanacheRepositoryBase<T, Long> {

    @PersistenceContext
    EntityManager em;

    protected Class<T> entityClass;
    private final String entitySimpleName;

    public BaseRepository(Class<T> entityClass) {
        this.entityClass = entityClass;
        this.entitySimpleName = entityClass.getSimpleName();
    }

    /**
     * Responsável por deletar uma entidade pelo seu identificador. Foi criado para ter mais controle nas transações.
     *
     * @param id Identificador da entidade
     */
    @Transactional
    public void deleteEntityById(Long id) {
        Query query = em.createQuery("DELETE FROM " + entitySimpleName + " e WHERE e.id = :id");
        query.setParameter("id", id);
        query.executeUpdate();
    }

    public Pagination buildPagination(Pageable pageable) {
        long numberOfRecords = count();
        long totalPages = numberOfRecords / pageable.getSize();
        return new Pagination(pageable.getPage(), totalPages, numberOfRecords);
    }

    public boolean existsById(Long id) {
        String query = String.format("FROM %s WHERE id = ?1", entitySimpleName);
        return count(query, id) > 0;
    }
}