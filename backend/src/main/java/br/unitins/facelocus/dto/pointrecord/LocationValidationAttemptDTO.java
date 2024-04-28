package br.unitins.facelocus.dto.pointrecord;

import java.time.LocalDateTime;

public record LocationValidationAttemptDTO(String latitude,
                                           String longitude,
                                           Double distanceInMeters,
                                           Double allowedDistanceInMeters,
                                           LocalDateTime dateTime,
                                           boolean validated) {
}

