package br.unitins.facelocus.mapper;

import br.unitins.facelocus.dto.LocalizacaoDTO;
import br.unitins.facelocus.model.Localizacao;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

@Mapper(config = QuarkusMappingConfig.class, unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface LocalizacaoMapper {

    Localizacao toEntity(LocalizacaoDTO localizacaoDTO);

    LocalizacaoDTO toResource(Localizacao localizacao);
}
