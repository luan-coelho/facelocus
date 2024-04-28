package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.pointrecord.AttendanceRecordResponseDTO;
import br.unitins.facelocus.dto.user.UserDTO;
import br.unitins.facelocus.model.AttendanceRecord;
import br.unitins.facelocus.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AttendanceRecordMapper {

    AttendanceRecordResponseDTO toResource(AttendanceRecord ar);

    User toEntity(UserDTO dto);
}
