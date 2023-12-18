package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.File;
import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class FotoRostoUsuario {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private File arquivo;
    private String nomeArquivo;
    private LocalDate dataUpload;
    private String caminhoArquivo;
    @OneToOne
    private Usuario usuario;

    @PrePersist
    public void gerarDataUploud(){
        this.dataUpload = LocalDate.now();
    }
}