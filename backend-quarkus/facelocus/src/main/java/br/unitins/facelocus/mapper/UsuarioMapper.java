package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.UsuarioDTO;
import br.unitins.facelocus.model.Usuario;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface UsuarioMapper {

    @Mapping(ignore = true, target = "senha")
    UsuarioDTO toResource(Usuario usuario);

    @Mapping(ignore = true, target = "id")
    Usuario toEntity(UsuarioDTO dto);

    Usuario copyProperties(Usuario target);
}
