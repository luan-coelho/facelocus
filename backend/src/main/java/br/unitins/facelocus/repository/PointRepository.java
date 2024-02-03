package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.Point;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class PointRepository extends BaseRepository<Point> {

    public PointRepository() {
        super(Point.class);
    }
}
