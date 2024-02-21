package br.unitins.facelocus.service;

import br.unitins.facelocus.model.Point;
import br.unitins.facelocus.repository.PointRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class PointService extends BaseService<Point, PointRepository> {
}
