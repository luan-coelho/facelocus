package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.EventoDTO;
import br.unitins.facelocus.model.Evento;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface EventoMapper {

    Evento toEntity(EventoDTO eventoDTO);

    EventoDTO toResource(Evento evento);
}
