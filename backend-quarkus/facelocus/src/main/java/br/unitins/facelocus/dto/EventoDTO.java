package br.unitins.facelocus.dto;

import java.util.List;

public record EventoDTO(String descricao, List<LocalizacaoDTO> localizacoes, boolean permitirSolicitacoesIngresso) {
}
