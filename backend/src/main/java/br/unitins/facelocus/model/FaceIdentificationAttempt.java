package br.unitins.facelocus.model;

import jakarta.persistence.*;
import lombok.*;

@EqualsAndHashCode(of = "id", callSuper = false)
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class FaceIdentificationAttempt {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    private boolean validated;
}
