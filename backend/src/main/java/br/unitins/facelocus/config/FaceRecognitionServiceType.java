package br.unitins.facelocus.config;

public enum FaceRecognitionServiceType {

    ALL_SERVICES,
    SPECIFIC_SERVICE,
    DEEP_FACE,
    INSIGHT_FACE,
    UNKNOWN;  // Um valor padrão para lidar com configurações desconhecidas ou não configuradas

    public static FaceRecognitionServiceType fromString(String serviceType) {
        if (serviceType != null) {
            for (FaceRecognitionServiceType type : FaceRecognitionServiceType.values()) {
                if (type.name().equalsIgnoreCase(serviceType)) {
                    return type;
                }
            }
        }
        return UNKNOWN;
    }

}
