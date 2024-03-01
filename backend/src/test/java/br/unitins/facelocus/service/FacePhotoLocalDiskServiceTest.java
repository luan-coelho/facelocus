package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.model.Event;
import br.unitins.facelocus.model.PointRecord;
import br.unitins.facelocus.service.facephoto.FacePhotoLocalDiskService;
import io.quarkus.test.TestTransaction;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@QuarkusTest
class FacePhotoLocalDiskServiceTest extends BaseTest {

    @Inject
    FacePhotoLocalDiskService faceRecognitionService;

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

  /*  @Test
    @TestTransaction
    @DisplayName("Deve realizar o uploud de uma foto de perfil de um usuário corretamente")
    void shouldCorrectlyUploadAUserFacePhoto() {
        MultipartData multipartData = new MultipartData();
        multipartData.fileName = "user1.jpg";
        multipartData.inputStream = getImageAsInputStream("user1.jpg");
        user1 = userService.findById(user1.getId());

        assertDoesNotThrow(() -> faceRecognitionService.profileUploud(user1.getId(), multipartData));
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

        assertDoesNotThrow(() -> faceRecognitionService.profileUploud(user1.getId(), multipartData));
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
        faceRecognitionService.profileUploud(user1.getId(), uploudProfilePhoto);

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
        faceRecognitionService.profileUploud(user1.getId(), uploudProfilePhoto);

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
    @DisplayName("Deve lançar uma exceção quando for detectado mais de um rosto")
    void shouldThrowExceptionWhenMultipleFacesDetected() {
        MultipartData uploudProfilePhoto = new MultipartData();
        uploudProfilePhoto.fileName = "user1.jpg";
        uploudProfilePhoto.inputStream = getImageAsInputStream("user1.jpg");
        faceRecognitionService.profileUploud(user1.getId(), uploudProfilePhoto);

        MultipartData validationPhotoUpload = new MultipartData();
        validationPhotoUpload.fileName = "user1_3.jpeg";
        validationPhotoUpload.inputStream = getImageAsInputStream("user1_3.jpeg");

        Exception exception = assertThrows(IllegalArgumentException.class,
                () -> faceRecognitionService.facePhotoValidation(user1.getId(), validationPhotoUpload)
        );

        assertEquals("Cada foto deve conter apenas um rosto", exception.getMessage());
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

        assertEquals("Sem foto de perfil não há como prosseguir com a validação", exception.getMessage());
    }*/
}