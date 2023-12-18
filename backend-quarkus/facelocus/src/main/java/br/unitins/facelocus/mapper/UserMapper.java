package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.UserDTO;
import br.unitins.facelocus.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface UserMapper {

    @Mapping(ignore = true, target = "password")
    UserDTO toResource(User user);

    @Mapping(ignore = true, target = "id")
    User toEntity(UserDTO dto);

    User copyProperties(User user);
}
