package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.ticketrequest.TicketRequestCreateDTO;
import br.unitins.facelocus.dto.ticketrequest.TicketRequestResponseDTO;
import br.unitins.facelocus.model.TicketRequest;
import org.mapstruct.*;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, uses = {EventMapper.class, UserMapper.class})
public interface TicketRequestMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "event", ignore = true)
    @Mapping(target = "requestStatus", ignore = true)
    TicketRequest toCreateEntity(TicketRequestCreateDTO ticketRequestDTO);

    @Mapping(source = "event", target = "event", qualifiedByName = "toCreateEntity")
    @Mapping(target = "id", ignore = true)
    TicketRequest toUpdateEntity(TicketRequestResponseDTO ticketRequestDTO);

    @Mapping(source = "user", target = "user", qualifiedByName = "toResource")
    TicketRequestResponseDTO toResource(TicketRequest ticketRequestDTO);

    @Mapping(target = "id", ignore = true)
    TicketRequest copyProperties(TicketRequest ticketRequestDTO, @MappingTarget TicketRequest existingTicketRequest);
}
