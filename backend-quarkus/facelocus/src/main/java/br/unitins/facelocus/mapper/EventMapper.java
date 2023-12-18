package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.EventDTO;
import br.unitins.facelocus.model.Event;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface EventMapper {

    Event toEntity(EventDTO eventDTO);

    EventDTO toResource(Event event);
}
