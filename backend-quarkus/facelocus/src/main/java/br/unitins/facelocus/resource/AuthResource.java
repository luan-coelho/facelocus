package br.unitins.facelocus.resource;

import br.unitins.facelocus.dto.UsuarioDTO;
import br.unitins.facelocus.mapper.UsuarioMapper;
import br.unitins.facelocus.model.Usuario;
import br.unitins.facelocus.service.UsuarioService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@Path("/auth")
public class AuthResource {

    @Inject
    UsuarioService usuarioService;

    @Inject
    UsuarioMapper usuarioMapper;

    @Path("/cadastrar")
    @POST
    public Response cadastrar(@Valid UsuarioDTO usuarioDTO) {
        Usuario usuario = usuarioMapper.toEntity(usuarioDTO);
        Usuario usuarioCadastrado = usuarioService.criar(usuario);
        UsuarioDTO dto = usuarioMapper.toResource(usuarioCadastrado);
        return Response.ok(dto).build();
    }
}
