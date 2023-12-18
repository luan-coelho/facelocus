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
public abstract class UserFacePhoto {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    private File file;
    private String fileName;
    private LocalDate uploudDate;
    private String filePath;
    @OneToOne
    private User user;

    @PrePersist
    public void generateUploudDate() {
        this.uploudDate = LocalDate.now();
    }
}