package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Evento {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String descricao;
    @OneToMany(mappedBy = "evento")
    private List<RegistroPonto> registrosPonto;
    @OneToMany(mappedBy = "evento")
    private List<Localizacao> localizacoes;
    @ManyToOne
    private Usuario administrador;
    @ManyToMany
    private List<Usuario> usuarios;
    private String codigo;
    private boolean permitirSolicitacoesIngresso;
    @OneToMany(mappedBy = "evento")
    private List<SolicitacaoIngresso> solicitacoes;
}