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
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String nome;
    private String sobreNome;
    private String email;
    private String cpf;
    private String senha;
    @OneToOne(mappedBy = "usuario")
    private FotoRostoUsuario fotoRostoUsuario;
    @OneToMany(mappedBy = "usuario")
    private List<Dispositivo> dispositivos;

    public String getNomeCompleto() {
        return this.nome.trim() + " " + this.sobreNome.trim();
    }
}