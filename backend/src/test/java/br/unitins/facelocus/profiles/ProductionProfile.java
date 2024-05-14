package br.unitins.facelocus.profiles;

import io.quarkus.test.junit.QuarkusTestProfile;

import java.util.Map;

public class ProductionProfile implements QuarkusTestProfile {

    @Override
    public Map<String, String> getConfigOverrides() {
        return Map.of(
                "quarkus.profile", "prod"
        );
    }

    @Override
    public String getConfigProfile() {
        return "prod";
    }
}
