package br.unitins.facelocus.mapper;

import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.dto.eventrequest.EventRequestCreateDTO;
import br.unitins.facelocus.dto.eventrequest.EventRequestResponseDTO;
import br.unitins.facelocus.model.EventRequest;
import org.mapstruct.*;

import java.util.List;

@Mapper(config = QuarkusMappingConfig.class,
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        uses = {EventMapper.class, UserMapper.class})
public interface EventRequestMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "event", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "type", ignore = true)
    EventRequest toCreateEntity(EventRequestCreateDTO ticketRequest);

    @Mapping(source = "event", target = "event", qualifiedByName = "toCreateEntity")
    @Mapping(target = "id", ignore = true)
    EventRequest toUpdateEntity(EventRequestResponseDTO eventRequest);

    @Mapping(source = "initiatorUser", target = "initiatorUser", qualifiedByName = "toResource")
    @Mapping(source = "targetUser", target = "targetUser", qualifiedByName = "toResource")
    EventRequestResponseDTO toResource(EventRequest eventRequest);

    List<EventRequestResponseDTO> toResource(List<EventRequest> eventRequest);

    DataPagination<EventRequestResponseDTO> toCreateEntity(DataPagination<EventRequest> dataPagination);

    @Mapping(target = "id", ignore = true)
    EventRequest copyProperties(EventRequest eventRequest, @MappingTarget EventRequest existingTicketRequest);
}
