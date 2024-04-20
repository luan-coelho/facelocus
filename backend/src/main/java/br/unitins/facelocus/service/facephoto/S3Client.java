package br.unitins.facelocus.service.facephoto;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Singleton;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;

@ApplicationScoped
public class S3Client {

    @ConfigProperty(name = "aws.access-key-id")
    String accessKeyId;

    @ConfigProperty(name = "aws.secret-access-key")
    String secretAccessKey;

    @ConfigProperty(name = "aws.region")
    String region;

    @Singleton
    public software.amazon.awssdk.services.s3.S3Client s3Client() {
        Region region = Region.of(this.region);
        return software.amazon.awssdk.services.s3.S3Client.builder()
                .credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials
                        .create(accessKeyId, secretAccessKey)))
                .region(region)
                .build();
    }
}
