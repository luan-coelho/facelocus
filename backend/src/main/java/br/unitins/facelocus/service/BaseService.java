package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.commons.pagination.Pagination;
import br.unitins.facelocus.repository.BaseRepository;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.Optional;

@SuppressWarnings({"CdiInjectionPointsInspection", "UnusedReturnValue", "rawtypes", "unchecked"})
public abstract class BaseService<T, R extends BaseRepository<T>> {

    @Inject
    public R repository;

    public List<T> findAll() {
        return this.repository.listAll();
    }

    public DataPagination findAllPaginated(Pageable pageable) {
        List list = repository.listAll();
        return buildPagination(list, pageable);
    }

    public boolean existsById(Long id) {
        return repository.existsById(id);
    }

    public boolean existsByIdWithThrows(Long id) {
        boolean exists = repository.existsById(id);
        if (!exists) {
            throw new NotFoundException("Recurso não encontrado pelo id");
        }
        return true;
    }

    public boolean existsByIdWithThrows(Long id, String throwsMessage) {
        boolean exists = repository.existsById(id);
        if (!exists) {
            throw new NotFoundException(throwsMessage);
        }
        return true;
    }

    public T findById(Long id) {
        return repository
                .findByIdOptional(id)
                .orElseThrow(() -> new NotFoundException("Recurso não encontrado pelo id"));
    }

    public Optional<T> findByIdOptional(Long id) {
        return repository.findByIdOptional(id);
    }

    @Transactional
    public T create(T entity) {
        repository.persist(entity);
        return entity;
    }

    @Transactional
    public void persistAll(List<T> entities) {
        this.repository.persist(entities);
    }

    @Transactional
    public T update(T entity) {
        return repository.getEntityManager().merge(entity);
    }

    public void deleteById(Long id) {
        existsByIdWithThrows(id);
        try {
            repository.deleteEntityById(id);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected DataPagination buildPagination(List data, Pageable pageable) {
        Pagination pagination = repository.buildPagination(pageable);
        return new DataPagination<>(data, pagination);
    }
}