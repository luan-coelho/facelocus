package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.eventrequest.ExportEventDTO;
import br.unitins.facelocus.model.Event;
import org.mapstruct.Mapper;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface EventExportMapper {

    @Named("toResource")
    ExportEventDTO toResource(Event user);
}
