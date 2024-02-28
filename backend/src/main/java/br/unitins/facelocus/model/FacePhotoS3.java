package br.unitins.facelocus.model;

import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class FacePhotoS3 extends FacePhoto {

    private String objectKey;
    private Long size;
    private String bucket;
}