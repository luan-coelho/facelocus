package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.model.UserFacePhoto;
import br.unitins.facelocus.model.User;

public interface FotoRostoUsuarioService {

    /**
     * Responsável por salvar uma imagem em determinado storage
     *
     * @param usuario          Usuário dono da foto.
     * @param fotoRostoUsuario Contém informações sobre o arquivo de foto de rosto de um usuário.
     * @return caminho do arquivo
     */
    String salvar(User usuario, UserFacePhoto fotoRostoUsuario);

    /**
     * Responsável por construir uma instância de foto de rosto de um usuário.
     *
     * @param multipartForm Contém dados necessários para construção de FotoRostoUsuario.
     * @return Instância de FotoRostoUsuario com todos os valores preenchidos.
     */
    UserFacePhoto construirInstancia(MultipartData multipartForm);
}
