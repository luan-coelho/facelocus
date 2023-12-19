package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.TicketRequestDTO;
import br.unitins.facelocus.model.TicketRequest;
import org.mapstruct.*;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, uses = {EventMapper.class, UserMapper.class})
public interface TicketRequestMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "event", ignore = true)
    @Mapping(target = "requestStatus", ignore = true)
    TicketRequest toCreateEntity(TicketRequestDTO ticketRequestDTO);

    @Mapping(source = "event", target = "event", qualifiedByName = "toCreateEntity")
    @Mapping(target = "id", ignore = true)
    TicketRequest toUpdateEntity(TicketRequestDTO ticketRequestDTO);

    @Mapping(source = "requested", target = "requested", qualifiedByName = "toResource")
    TicketRequestDTO toResource(TicketRequest ticketRequestDTO);

    @Mapping(target = "id", ignore = true)
    TicketRequest copyProperties(TicketRequest ticketRequestDTO, @MappingTarget TicketRequest existingTicketRequest);
}
