package br.unitins.facelocus.mapper;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.dto.pointrecord.PointRecordDTO;
import br.unitins.facelocus.dto.pointrecord.PointRecordResponseDTO;
import br.unitins.facelocus.model.PointRecord;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface PointRecordMapper {

    @Named("toResource")
    PointRecordResponseDTO toResource(PointRecord pointRecord);

    DataPagination<PointRecordResponseDTO> toResource(DataPagination<PointRecord> dataPagination);

    @Mapping(ignore = true, target = "id")
    PointRecord toEntity(PointRecordDTO dto);

    PointRecord copyProperties(PointRecord pointRecord);
}
