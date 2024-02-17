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

import static org.junit.jupiter.api.Assertions.*;

@SuppressWarnings({"resource", "ResultOfMethodCallIgnored"})
@QuarkusTest
class FaceRecognitionServiceTest extends BaseTest {

    @Inject
    FaceRecognitionService faceRecognitionService;

    @Inject
    ImageFileService imageFileService;

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
        multipartData.fileName = "images/user1.jpg";
        multipartData.inputStream = getImageAsInputStream("user1.jpg");
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

    @Test
    @TestTransaction
    @DisplayName("Deve detectar um rosto com sucesso")
    void shouldDetectFaceSuccessfully() {
        MultipartData uploudProfilePhoto = new MultipartData();
        uploudProfilePhoto.fileName = "images/user1.jpg";
        uploudProfilePhoto.inputStream = getImageAsInputStream("user1.jpg");
        faceRecognitionService.facePhotoProfileUploud(user1.getId(), uploudProfilePhoto);

        MultipartData validationPhotoUpload = new MultipartData();
        validationPhotoUpload.fileName = "images/user1_2.jpg";
        validationPhotoUpload.inputStream = getImageAsInputStream("user1_2.jpg");

        assertDoesNotThrow(() -> faceRecognitionService.facePhotoValidation(user1.getId(), validationPhotoUpload));
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando rosto não for identificado")
    void shouldThrowExceptionWhenUserNotDetected() {
        MultipartData uploudProfilePhoto = new MultipartData();
        uploudProfilePhoto.fileName = "images/user1.jpg";
        uploudProfilePhoto.inputStream = getImageAsInputStream("user1.jpg");
        faceRecognitionService.facePhotoProfileUploud(user1.getId(), uploudProfilePhoto);

        MultipartData validationPhotoUpload = new MultipartData();
        validationPhotoUpload.fileName = "images/user2.jpg";
        validationPhotoUpload.inputStream = getImageAsInputStream("user2.jpg");

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> faceRecognitionService.facePhotoValidation(user1.getId(), validationPhotoUpload)
        );

        assertEquals("Rosto não identificado", exception.getMessage());
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando o usuário ainda não tiver foto de rosto cadastrada")
    void shouldThrowExceptionWhenUserHasNoProfilePictureRegistered() {
        MultipartData multipartData = new MultipartData();
        multipartData.fileName = "images/user1.jpg";
        multipartData.inputStream = getImageAsInputStream("user1.jpg");

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> faceRecognitionService.facePhotoValidation(user1.getId(), multipartData)
        );

        assertEquals("O usuário ainda não há nenhuma foto de perfil. Realize o uploud.", exception.getMessage());
    }

    public InputStream getImageAsInputStream(String imageName) {
        try {
            ClassLoader classLoader = getClass().getClassLoader();
            InputStream imageStream = classLoader.getResourceAsStream("images/" + imageName);
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