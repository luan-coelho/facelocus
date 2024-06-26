package br.unitins.facelocus.mapper;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.dto.eventrequest.EventDTO;
import br.unitins.facelocus.dto.eventrequest.ExportEventDTO;
import br.unitins.facelocus.model.Event;
import org.mapstruct.*;

@Mapper(config = QuarkusMappingConfig.class,
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        uses = {UserMapper.class})
public interface EventMapper {

    @Named("toCreateEntity")
    Event toCreateEntity(EventDTO eventDTO);

    @Mapping(ignore = true, target = "pointRecords")
    @Mapping(ignore = true, target = "locations")
    @Mapping(ignore = true, target = "administrator")
    @Mapping(ignore = true, target = "code")
    @Mapping(ignore = true, target = "ticketRequests")
    Event toUpdateEntity(EventDTO eventDTO);

    @Named("toResource")
    @Mapping(source = "administrator", target = "administrator", qualifiedByName = "toResource")
    EventDTO toResource(Event event);

    DataPagination<EventDTO> toResource(DataPagination<Event> events);

    @Mapping(target = "id", ignore = true)
    Event toUpdateEntity(Event event, @MappingTarget Event existingEvent);

}
