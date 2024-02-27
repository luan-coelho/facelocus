package br.unitins.facelocus.service.facephoto;

import br.unitins.facelocus.commons.MultipartData;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;

import java.io.ByteArrayInputStream;

@ApplicationScoped
public class FacePhotoS3Service implements FacePhotoService {

    @Transactional
    @Override
    public void profileUploud(Long userId, MultipartData multipartData) {
    }

    @Override
    public ByteArrayInputStream getByteArrayInputStreamByUser(Long userId) {
        return null;
    }
}
