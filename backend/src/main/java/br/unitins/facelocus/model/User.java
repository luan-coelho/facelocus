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
@Table(name = "tb_user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String name;
    private String surname;
    private String email;
    private String cpf;
    private String password;
    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL)
    private UserFacePhoto facePhoto;
    @OneToMany(mappedBy = "user")
    private List<Device> devices;
    @ManyToMany(mappedBy = "users")
    private List<Event> events;
}