package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.PointRecord;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.eclipse.microprofile.config.ConfigProvider;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.*;

@SuppressWarnings({"resource", "ResultOfMethodCallIgnored"})
@QuarkusTest
class FaceRecognitionServiceTest extends BaseTest {

    private static final String USER_HOME = ConfigProvider.getConfig().getValue("files.users.facephoto.basepath", String.class);
    private static final String RESOURCES_DIRECTORY = ConfigProvider.getConfig().getValue("files.users.facephoto.resources", String.class);
    private static final String SEPARATOR = File.separator; // "\" ou "/"

    @Inject
    FaceRecognitionService faceRecognitionService;

    @Inject
    UserService userService;

    @Inject
    EventService eventService;

    @Inject
    PointRecordService pointRecordService;

    @BeforeEach
    public void setup() {
        user1 = getUser();
    }

    @AfterAll
    public static void after() {
        String resourcesPath = USER_HOME + SEPARATOR + RESOURCES_DIRECTORY;
        removeImageFolder(resourcesPath);
    }

    @Test
    @TestTransaction
    @DisplayName("Deve realizar o uploud de uma foto de perfil de um usuário corretamente")
    void shouldCorrectlyUploadAUserFacePhoto() {
        MultipartData multipartData = new MultipartData();
        multipartData.fileName = "user1.jpg";
        multipartData.inputStream = getImageAsInputStream("user1.jpg");
        user1 = userService.findById(user1.getId());

        assertDoesNotThrow(() -> faceRecognitionService.facePhotoProfileUploud(user1.getId(), multipartData));
    }

    @Test
    @TestTransaction
    @DisplayName("Deve realizar a troca de uma foto de perfil de um usuário corretamente")
    void shouldCorrectlyChangeUserProfilePicture() {
        MultipartData multipartData = new MultipartData();
        multipartData.fileName = "user2.jpg";
        multipartData.inputStream = getImageAsInputStream("user2.jpg");
        user1 = userService.findById(user1.getId());

        List<Event> events = eventService.findAllByUser(user1.getId());
        List<PointRecord> pointsRecord = pointRecordService.findAllByUser(user1.getId());

        assertDoesNotThrow(() -> faceRecognitionService.facePhotoProfileUploud(user1.getId(), multipartData));
        assertEquals(0, events.size()); // Deve ter desvinculado o usuário de todos os eventos
        assertEquals(0, pointsRecord.size()); // Deve ter desvinculado o usuário de todos os registros de ponto
    }

    @Test
    @TestTransaction
    @DisplayName("Deve detectar um rosto com sucesso")
    void shouldDetectFaceSuccessfully() {
        MultipartData uploudProfilePhoto = new MultipartData();
        uploudProfilePhoto.fileName = "user1.jpg";
        uploudProfilePhoto.inputStream = getImageAsInputStream("user1.jpg");
        faceRecognitionService.facePhotoProfileUploud(user1.getId(), uploudProfilePhoto);

        MultipartData validationPhotoUpload = new MultipartData();
        validationPhotoUpload.fileName = "user1_2.jpg";
        validationPhotoUpload.inputStream = getImageAsInputStream("user1_2.jpg");

        assertDoesNotThrow(() -> faceRecognitionService.facePhotoValidation(user1.getId(), validationPhotoUpload));
    }

    @Test
    @TestTransaction
    @DisplayName("Deve lançar uma exceção quando rosto não for identificado")
    void shouldThrowExceptionWhenUserNotDetected() {
        MultipartData uploudProfilePhoto = new MultipartData();
        uploudProfilePhoto.fileName = "user1.jpg";
        uploudProfilePhoto.inputStream = getImageAsInputStream("user1.jpg");
        faceRecognitionService.facePhotoProfileUploud(user1.getId(), uploudProfilePhoto);

        MultipartData validationPhotoUpload = new MultipartData();
        validationPhotoUpload.fileName = "user2.jpg";
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
        multipartData.fileName = "user1.jpg";
        multipartData.inputStream = getImageAsInputStream("user1.jpg");

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> faceRecognitionService.facePhotoValidation(user1.getId(), multipartData)
        );

        assertEquals("O usuário ainda não há nenhuma foto de perfil. Realize o uploud.", exception.getMessage());
    }

    private InputStream getImageAsInputStream(String imageName) {
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

    private static void removeImageFolder(String path) {
        String patternString = "(.*/users/)\\d+/.*";
        Pattern pattern = Pattern.compile(patternString);
        Matcher matcher = pattern.matcher(path);

        path = matcher.replaceFirst("$1");
        File imageFolder = new File(path);

        if (imageFolder.exists()) {
            Path folder = Paths.get(imageFolder.getAbsolutePath());

            try {
                Files.walk(folder)
                        .sorted(Comparator.reverseOrder())
                        .map(Path::toFile)
                        .forEach(File::delete);
            } catch (IOException e) {
                fail("Pasta não deletada");
            }
        }
    }
}