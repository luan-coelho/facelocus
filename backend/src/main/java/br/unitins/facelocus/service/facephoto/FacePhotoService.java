package br.unitins.facelocus.service.facephoto;

import br.unitins.facelocus.commons.MultipartData;

public interface FacePhotoService {

    void profileUploud(Long userId, MultipartData multipartData);

    byte[] getFacePhotoByUser(Long userId);

    void facePhotoValidation(Long userId, MultipartData multipartBody);
}
