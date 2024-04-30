package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

@EqualsAndHashCode(of = "id", callSuper = false)
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class FacePhoto extends DefaultEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private String fileName;

    @ManyToOne
    private User user;
}