package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.eventrequest.EventRequestCreateDTO;
import br.unitins.facelocus.dto.eventrequest.EventRequestResponseDTO;
import br.unitins.facelocus.model.EventRequest;
import org.mapstruct.*;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, uses = {EventMapper.class, UserMapper.class})
public interface EventRequestMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "event", ignore = true)
    @Mapping(target = "requestStatus", ignore = true)
    @Mapping(target = "requestType", ignore = true)
    EventRequest toCreateEntity(EventRequestCreateDTO ticketRequest);

    @Mapping(source = "event", target = "event", qualifiedByName = "toCreateEntity")
    @Mapping(target = "id", ignore = true)
    EventRequest toUpdateEntity(EventRequestResponseDTO eventRequest);

    @Mapping(source = "initiatorUser", target = "initiatorUser", qualifiedByName = "toResource")
    @Mapping(source = "targetUser", target = "targetUser", qualifiedByName = "toResource")
    EventRequestResponseDTO toResource(EventRequest eventRequest);

    @Mapping(target = "id", ignore = true)
    EventRequest copyProperties(EventRequest eventRequest, @MappingTarget EventRequest existingTicketRequest);
}
