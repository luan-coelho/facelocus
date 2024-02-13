package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.fail;

@SuppressWarnings({"resource", "ResultOfMethodCallIgnored"})
@QuarkusTest
class FaceRecognitionServiceTest extends BaseTest {

    @Inject
    FaceRecognitionService faceRecognitionService;

    @Inject
    UserService userService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
    }

    @Test
    @TestTransaction
    @DisplayName("Deve realizar o uploud de uma foto de rosto de um usuário corretamente")
    void shouldCorrectlyUploadAUserFacePhoto() {
        MultipartData multipartData = new MultipartData();
        multipartData.fileName = "images/user.jpg";
        multipartData.inputStream = getImageAsInputStream();
        faceRecognitionService.facePhotoProfileUploud(user1.getId(), multipartData);
        user1 = userService.findById(user1.getId());
        String filePath = user1.getFacePhoto().getFilePath();
        File image = null;
        try {
            image = new File(filePath);
        } catch (Exception e) {
            fail();
        } finally {
            if (image != null) {
                Path folder = Paths.get(image.getAbsolutePath());
                try {
                    Files.walk(folder)
                            .map(Path::toFile)
                            .forEach(File::delete);
                } catch (IOException e) {
                    fail("Imagem não deletada");
                }
            }
        }
    }

    public InputStream getImageAsInputStream() {
        try {
            ClassLoader classLoader = getClass().getClassLoader();
            InputStream imageStream = classLoader.getResourceAsStream("images/user.jpg");
            if (imageStream == null) {
                return null;
            }
            BufferedImage image = ImageIO.read(imageStream);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "jpg", baos);

            byte[] bytes = baos.toByteArray();

            return new ByteArrayInputStream(bytes);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}