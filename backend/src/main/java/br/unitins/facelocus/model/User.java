package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@EqualsAndHashCode(of = "id", callSuper = false)
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_user")
public class User extends DefaultEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private String name;

    private String surname;

    private String email;

    private String cpf;

    private String password;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL)
    private FacePhoto facePhoto;

  /*  @OneToMany(mappedBy = "user")
    private List<Device> devices;*/

    @ManyToMany(mappedBy = "users")
    private List<Event> events;
}