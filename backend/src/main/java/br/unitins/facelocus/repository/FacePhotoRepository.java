package br.unitins.facelocus.repository;

import br.unitins.facelocus.model.FacePhoto;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class FacePhotoRepository extends BaseRepository<FacePhoto> {

    public FacePhotoRepository() {
        super(FacePhoto.class);
    }
}
