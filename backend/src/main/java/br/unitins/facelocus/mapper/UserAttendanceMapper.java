package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.pointrecord.UserAttendanceResponseDTO;
import br.unitins.facelocus.model.UserAttendance;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface UserAttendanceMapper {

    @Named("toResource")
    UserAttendanceResponseDTO toResource(UserAttendance userAttendance);

    List<UserAttendanceResponseDTO> toResource(List<UserAttendance> userAttendance);

    @Mapping(ignore = true, target = "id")
    UserAttendance toEntity(UserAttendanceResponseDTO dto);
}
