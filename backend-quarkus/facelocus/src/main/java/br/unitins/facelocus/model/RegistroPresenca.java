package br.unitins.facelocus.model;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class RegistroPresenca {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private LocalDateTime dataHora;
    @ManyToOne
    private Usuario usuario;
    @ManyToOne
    private FotoRostoUsuario fotoRostoUsuario;
    @ManyToOne
    private Ponto ponto;
}