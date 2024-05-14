package br.unitins.facelocus.service;

import br.unitins.facelocus.profiles.ProductionProfile;
import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.junit.TestProfile;
import jakarta.inject.Inject;
import org.junit.jupiter.api.Test;

import java.util.List;

@QuarkusTest
@TestProfile(ProductionProfile.class)
public class AwsS3Test {

    @Inject
    S3Service s3Service;

    @Test
    public void deveGerarLinksUrlsParaOServicoDeReconhecimentoFacial() {
        List<String> keys = s3Service.listAllKeys();
        System.out.println("==== KEYS ====");
        s3Service.generateCurlCommandsToFile(keys);
        System.out.println("==============");
    }
}
