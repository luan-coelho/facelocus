package br.unitins.facelocus.model;

import jakarta.persistence.Entity;
import lombok.*;

@EqualsAndHashCode(callSuper = true)
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