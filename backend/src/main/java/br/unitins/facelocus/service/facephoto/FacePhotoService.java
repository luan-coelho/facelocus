package br.unitins.facelocus.service.facephoto;

import br.unitins.facelocus.commons.MultipartData;

import java.io.ByteArrayInputStream;

public interface FacePhotoService {

    void profileUploud(Long userId, MultipartData multipartData);

    ByteArrayInputStream getByteArrayInputStreamByUser(Long userId);
}
