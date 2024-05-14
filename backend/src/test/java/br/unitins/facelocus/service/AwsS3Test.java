package br.unitins.facelocus.service;

import br.unitins.facelocus.profiles.ProductionProfile;
import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.junit.TestProfile;
import org.junit.jupiter.api.Test;

import javax.inject.Inject;
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
        keys.forEach(System.out::println);
        System.out.println("==============");
    }
}
