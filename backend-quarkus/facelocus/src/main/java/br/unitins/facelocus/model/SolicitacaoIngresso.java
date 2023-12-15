package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class SolicitacaoIngresso {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String codigo;
    private LocalDateTime dataHoraLimite;
    @ManyToOne
    private Evento evento;
    private SituacaoSolicitacao situacao;
    @ManyToOne
    private Usuario usuario;
}
