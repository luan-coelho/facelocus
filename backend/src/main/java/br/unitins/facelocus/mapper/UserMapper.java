package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.UserDTO;
import br.unitins.facelocus.dto.UserResponseDTO;
import br.unitins.facelocus.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface UserMapper {

    @Named("toResource")
    UserResponseDTO toResource(User user);

    @Mapping(ignore = true, target = "id")
    User toEntity(UserDTO dto);

    User copyProperties(User user);
}
