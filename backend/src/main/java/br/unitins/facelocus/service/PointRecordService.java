package br.unitins.facelocus.service;

import br.unitins.facelocus.commons.MultipartData;
import br.unitins.facelocus.commons.TaskQueueManager;
import br.unitins.facelocus.commons.pagination.DataPagination;
import br.unitins.facelocus.commons.pagination.Pageable;
import br.unitins.facelocus.dto.pointrecord.LocationValidationAttemptDTO;
import br.unitins.facelocus.dto.pointrecord.PointRecordChangeRadiusMeters;
import br.unitins.facelocus.dto.pointrecord.PointRecordResponseDTO;
import br.unitins.facelocus.dto.user.UserFacePhotoValidation;
import br.unitins.facelocus.dto.webservice.FaceRecognitionAllServices;
import br.unitins.facelocus.dto.webservice.ServiceResult;
import br.unitins.facelocus.mapper.PointRecordMapper;
import br.unitins.facelocus.model.*;
import br.unitins.facelocus.repository.PointRecordRepository;
import br.unitins.facelocus.service.facephoto.FacePhotoS3Service;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;
import org.hibernate.Hibernate;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@ApplicationScoped
public class PointRecordService extends BaseService<PointRecord, PointRecordRepository> {

    @Inject
    PointRecordMapper pointRecordMapper;

    @Inject
    EventService eventService;

    @Inject
    LocationService locationService;

    @Inject
    AttendanceRecordService attendanceRecordService;

    @Inject
    UserService userService;

    @Inject
    FacePhotoS3Service faceRecognitionService;

    @Inject
    TaskQueueManager taskQueueManager;

    /**
     * Responsável por buscar todos os registros de ponto vinculados a um usuário
     *
     * @param pageable Informações de paginação
     * @param userId   Identificador do usuário
     * @return Dados paginados de registros de ponto
     */
    public DataPagination<PointRecordResponseDTO> findAllByUser(Pageable pageable, Long userId) {
        DataPagination<PointRecord> dataPagination = this.repository.findAllByUser(pageable, userId);
        return pointRecordMapper.toResource(dataPagination);
    }

    public List<PointRecord> findAllByUser(Long userId) {
        return this.repository.findAllByUser(userId);
    }

    public List<PointRecord> findAllByDate(Long userId, LocalDate date) {
        return this.repository.findAllByDate(userId, date);
    }

    public List<PointRecord> findAllByEvent(Long eventId) {
        return this.repository.findAllByEvent(eventId);
    }

    @Override
    public PointRecord findById(Long pointRecordId) {
        return super.findByIdOptional(pointRecordId)
                .orElseThrow(() -> new NotFoundException("Registro de ponto não encontrado pelo id"));
    }

    @Transactional
    @Override
    public PointRecord create(PointRecord pointRecord) {
        validations(pointRecord);
        super.create(pointRecord);
        return findById(pointRecord.getId());
    }

    private void validations(PointRecord pointRecord) {
        if (pointRecord.getEvent() == null || pointRecord.getEvent().getId() == null) {
            throw new IllegalArgumentException("Informe o evento");
        }

        if (pointRecord.getLocation() == null || pointRecord.getLocation().getId() == null) {
            throw new IllegalArgumentException("Ative o fator de Localização e informe a localização");
        }

        if (pointRecord.getPoints() == null || pointRecord.getPoints().isEmpty()) {
            throw new IllegalArgumentException("É necessário informar pelo menos um intervalo de ponto");
        }

        if (pointRecord.getFactors() == null || pointRecord.getFactors().isEmpty()) {
            throw new IllegalArgumentException("Informe pelo menos um fator");
        }

        Event event = eventService.findById(pointRecord.getEvent().getId());
        pointRecord.setEvent(event);

        validateDate(pointRecord.getDate());
        validateUserPoints(pointRecord);
        createUsersAttendances(pointRecord);
        validateFactors(pointRecord);
        validateLocation(pointRecord, pointRecord.getLocation());
    }

    private void validateLocation(PointRecord pointRecord, Location location) {
        List<Location> locations = pointRecord.getEvent().getLocations();
        Set<Factor> factors = pointRecord.getFactors();
        if (factors.contains(Factor.INDOOR_LOCATION) && !locations.contains(location)) {
            throw new IllegalArgumentException("Informe uma localização do evento");
        }

        if (pointRecord.getAllowableRadiusInMeters() == null || pointRecord.getAllowableRadiusInMeters() == 0) {
            throw new IllegalArgumentException("Informe o raio permitido em metros");
        }
    }

    /**
     * Valida se uma data é igual ou depois de hoje
     *
     * @param date Data
     */
    private void validateDate(LocalDate date) {
        if (date.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("A data deve ser igual ou depois do dia de hoje");
        }
    }

    /**
     * Responsável por validar os fatores de um registro de ponto
     *
     * @param pointRecord Registro de ponto
     */
    private void validateFactors(PointRecord pointRecord) {
        Set<Factor> factors = pointRecord.getFactors();

        if (factors == null || factors.isEmpty()) {
            return;
        }

        if (factors.contains(Factor.INDOOR_LOCATION)) {
            if (pointRecord.getAllowableRadiusInMeters() == null || pointRecord.getAllowableRadiusInMeters() == 0) {
                throw new IllegalArgumentException("Informe o raio permitido em metros");
            }

            if (pointRecord.getLocation() == null || pointRecord.getLocation().getId() == null) {
                throw new IllegalArgumentException("Informe a localização");
            }

            Location location = locationService.findById(pointRecord.getLocation().getId());
            pointRecord.setLocation(location);
        } /*else {
            pointRecord.setAllowableRadiusInMeters(null);
        }*/
    }

    /**
     * Responsável por validar os pontos de um registro de ponto
     *
     * @param pr Registro de ponto
     */
    private void validateUserPoints(PointRecord pr) {
        LocalDateTime lastDatetime = null;

        for (Point point : pr.getPoints()) {
            validatePoint(pr, point, lastDatetime);

            lastDatetime = point.getFinalDate().withSecond(0).withNano(0);
        }
    }

    private void validatePoint(PointRecord pointRecord, Point point, LocalDateTime lastDatetime) {
        LocalDate prDate = pointRecord.getDate();
        LocalDateTime startTime = point.getInitialDate()
                .withYear(prDate.getYear())
                .withMonth(prDate.getMonthValue())
                .withDayOfMonth(prDate.getDayOfMonth())
                .withSecond(0)
                .withNano(0);
        LocalDateTime endTime = point.getFinalDate()
                .withYear(prDate.getYear())
                .withMonth(prDate.getMonthValue())
                .withDayOfMonth(prDate.getDayOfMonth())
                .withSecond(0)
                .withNano(0);

        if (!startTime.isBefore(endTime)) {
            throw new IllegalArgumentException("A hora inicial de um ponto deve ser antes da final");
        }

        if (lastDatetime != null && !startTime.isAfter(lastDatetime)) {
            throw new IllegalArgumentException("Cada intervalo de ponto deve ter a hora superior ao anterior");
        }

        point.setInitialDate(startTime);
        point.setFinalDate(endTime);
        point.setPointRecord(pointRecord);
    }

    @Transactional
    public void createUsersAttendancesByPointRecord(Long pointRecordId, Long userId) {
        PointRecord pointRecord = findById(pointRecordId);
        User user = userService.findById(userId);

        if (pointRecord.getEvent().getAdministrator().getId().equals(userId)) {
            throw new IllegalArgumentException("O administrador do evento não pode ser vinculado como participante");
        }

        boolean userFound = false;
        for (UserAttendance ua : pointRecord.getUsersAttendances()) {
            if (ua.getUser().getId().equals(userId)) {
                userFound = true;
                break;
            }
        }

        if (userFound) {
            throw new IllegalArgumentException("Usuário já possui registro de presença");
        }

        UserAttendance userAttendance = createUserAttendanceByUser(pointRecord, user);
        pointRecord.getUsersAttendances().add(userAttendance);

        update(pointRecord);
    }

    /**
     * Cria registros de presença para cada usuário cadastrado no evento, conforme o
     * número de pontos.
     *
     * @param pointRecord Registro de Ponto
     */
    private void createUsersAttendances(PointRecord pointRecord) {
        if (pointRecord.getEvent().getUsers() == null || pointRecord.getEvent().getUsers().isEmpty()) {
            return;
        }

        List<UserAttendance> usersAttendances = new ArrayList<>();

        for (User user : pointRecord.getEvent().getUsers()) {
            UserAttendance userAttendance = createUserAttendanceByUser(pointRecord, user);
            usersAttendances.add(userAttendance);
        }
        pointRecord.setUsersAttendances(usersAttendances);
    }

    private UserAttendance createUserAttendanceByUser(PointRecord pointRecord, User user) {
        List<AttendanceRecord> attendanceRecords = new ArrayList<>();

        UserAttendance userAttendance = new UserAttendance();
        userAttendance.setUser(user);
        userAttendance.setAttendanceRecords(attendanceRecords);
        userAttendance.setPointRecord(pointRecord);

        for (Point point : pointRecord.getPoints()) {
            AttendanceRecord attendanceRecord = createAttendanceRecord(point);
            attendanceRecord.setUserAttendance(userAttendance);
            attendanceRecords.add(attendanceRecord);
        }
        return userAttendance;
    }

    private static AttendanceRecord createAttendanceRecord(Point point) {
        AttendanceRecord attendanceRecord = new AttendanceRecord();
        attendanceRecord.setStatus(AttendanceRecordStatus.PENDING);
        attendanceRecord.setPoint(point);
        return attendanceRecord;
    }

    /**
     * Alterna a situação de um registro de ponto para iniciado 'true' ou parado
     * 'false'
     *
     * @param pointRecordId Identificador do registro de ponto
     */
    @Transactional
    public void toggleActivity(Long pointRecordId) {
        PointRecord pointRecord = findById(pointRecordId);
        pointRecord.setInProgress(!pointRecord.isInProgress());
        update(pointRecord);
    }

    /**
     * Adiciona um fator a um registro de ponto
     *
     * @param pointRecordId Identificador do registro de ponto
     * @param factor        Fator que será adicionado
     */
    @Transactional
    public void addFactor(Long pointRecordId, Factor factor) {
        PointRecord pointRecord = findById(pointRecordId);
        pointRecord.getFactors().add(factor);
        update(pointRecord);
    }

    /**
     * Remove um fator de um registro de ponto
     *
     * @param pointRecordId Identificador do registro de ponto
     * @param factor        Fator que será removido
     */
    @Transactional
    public void removeFactor(Long pointRecordId, Factor factor) {
        PointRecord pointRecord = findById(pointRecordId);
        pointRecord.getFactors().remove(factor);
        update(pointRecord);
    }

    @Transactional
    public void unlinkUserFromAll(Long userId) {
        List<PointRecord> pointsRecord = this.repository.findAllByUser(userId);

        for (PointRecord pointRecord : pointsRecord) {
            for (UserAttendance userAttendance : pointRecord.getUsersAttendances()) {
                if (userAttendance.getUser().getId().equals(userId)) {
                    pointRecord.getUsersAttendances().remove(userAttendance);
                    update(pointRecord);
                    return;
                }
            }
        }
    }

    @Transactional
    public void validateUserPoints(List<AttendanceRecord> attendancesRecord) {
        for (AttendanceRecord attendanceRecord : attendancesRecord) {
            AttendanceRecord ar = attendanceRecordService.findById(attendanceRecord.getId());
            ar.setStatus(AttendanceRecordStatus.VALIDATED);
            ar.setValidatedByAdministrator(true);
            attendanceRecordService.update(ar);
        }
    }

    @Transactional
    public void changeDate(Long pointRecordId, LocalDate newDate) {
        validateDate(newDate);
        PointRecord pointRecord = findById(pointRecordId);
        pointRecord.setDate(newDate);
        for (Point point : pointRecord.getPoints()) {
            LocalDateTime startTime = point.getInitialDate()
                    .withYear(newDate.getYear())
                    .withMonth(newDate.getMonthValue())
                    .withDayOfMonth(newDate.getDayOfMonth())
                    .withSecond(0)
                    .withNano(0);
            LocalDateTime endTime = point.getFinalDate()
                    .withYear(newDate.getYear())
                    .withMonth(newDate.getMonthValue())
                    .withDayOfMonth(newDate.getDayOfMonth())
                    .withSecond(0)
                    .withNano(0);
            point.setInitialDate(startTime);
            point.setFinalDate(endTime);
        }
        update(pointRecord);
    }

    @Transactional
    public void changeAllowedRadiusInMeters(Long pointRecordId, PointRecordChangeRadiusMeters dto) {
        PointRecord pointRecord = findById(pointRecordId);
        if (pointRecord.getFactors().contains(Factor.INDOOR_LOCATION)) {
            pointRecord.setAllowableRadiusInMeters(dto.allowableRadiusInMeters());
            update(pointRecord);
        }
    }

    @Transactional
    public void changeLocation(Long pointRecordId, Long locationId) {
        PointRecord pointRecord = findById(pointRecordId);
        Location location = locationService.findById(locationId);
        validateLocation(pointRecord, location);
        if (!pointRecord.getLocation().equals(location)) {
            pointRecord.setLocation(location);
            update(pointRecord);
        }
    }

    @SuppressWarnings("CommentedOutCode")
    @Transactional
    public void validateFacialRecognitionFactorForAttendanceRecord(Long attendanceRecordId,
                                                                   MultipartData multipartData) {
        taskQueueManager.submitTask(() -> {
            AttendanceRecord attendanceRecord = attendanceRecordService.findById(attendanceRecordId);
            checkFacialRecognitionValidity(attendanceRecord);

            User user = attendanceRecord.getUserAttendance().getUser();
            user = userService.findById(user.getId());

            UserFacePhotoValidation validation = faceRecognitionService.generateFacePhotoValidation(
                    user,
                    multipartData
            );

            FaceRecognitionValidationAttempt attempt = new FaceRecognitionValidationAttempt();
            attempt.setFacePhoto(validation.getFacePhoto());
            attempt.setAttendanceRecord(attendanceRecord);

            boolean faceDetected = validation.isFaceDetected();

            attendanceRecord.setStatus(faceDetected ?
                    AttendanceRecordStatus.VALIDATED :
                    AttendanceRecordStatus.NOT_VALIDATED);
            attendanceRecord.getFrValidationAttempts().add(attempt);

            attempt.setValidated(faceDetected);
            attempt.setDateTime(LocalDateTime.now());
            /*FaceRecognitionAllServices recognitionResult = buildFaceRecognitionResult(validation.getRecognitionResult());
            recognitionResult.setFaceRecognitionValidationAttempt(attempt);*/
            attendanceRecordService.update(attendanceRecord);

            if (!faceDetected) {
                throw new IllegalArgumentException("Face não reconhecida. Tente novamente");
            }
        });
    }

    @SuppressWarnings("unused")
    private FaceRecognitionAllServices buildFaceRecognitionResult(FaceRecognitionAllServices recognitionResult) {
        recognitionResult.getFaceRecognition().setServiceType(ServiceResult.ServiceType.FACE_RECOGNITION);
        recognitionResult.getDeepface().setServiceType(ServiceResult.ServiceType.DEEPFACE);
        recognitionResult.getInsightface().setServiceType(ServiceResult.ServiceType.INSIGHTFACE);
        return recognitionResult;
    }

    public void validateLocationFactorForAttendanceRecord(Long attendanceRecordId,
                                                          LocationValidationAttemptDTO attemptDto) {
        AttendanceRecord attendanceRecord = attendanceRecordService.findById(attendanceRecordId);
        PointRecord pointRecord = attendanceRecord.getPoint().getPointRecord();
        Set<Factor> factors = pointRecord.getFactors();
        boolean hasLocationFactor = factors.contains(Factor.INDOOR_LOCATION);
        if (!hasLocationFactor) {
            throw new IllegalArgumentException("O registro de ponto não possui o fator de localização ativo");
        }

        if (factors.size() == 1 && attemptDto.validated()) {
            attendanceRecord.setStatus(AttendanceRecordStatus.VALIDATED);
        }

        LocationValidationAttempt attempt = pointRecordMapper.toEntity(attemptDto);
        attempt.setAttendanceRecord(attendanceRecord);
        List<LocationValidationAttempt> attempts = attendanceRecord.getLocationValidationAttempts();
        Hibernate.initialize(attempts);
        attempts.add(attempt);
        attendanceRecord.setLocationValidatedSuccessfully(true);
        attendanceRecordService.update(attendanceRecord);
    }

    private void checkFacialRecognitionValidity(AttendanceRecord attendanceRecord) {
        PointRecord pointRecord = attendanceRecord.getPoint().getPointRecord();
        Set<Factor> factors = pointRecord.getFactors();

        if (!factors.contains(Factor.FACIAL_RECOGNITION)) {
            throw new IllegalArgumentException("O registro de ponto não possui o fator de reconhecimento facial ativo");
        }

        if (factors.contains(Factor.INDOOR_LOCATION)) {
            if (attendanceRecord.getLocationValidationAttempts()
                    .stream()
                    .noneMatch(LocationValidationAttempt::isValidated)) {
                String message = "É necessário validar a localização antes de validar o reconhecimento facial";
                throw new IllegalArgumentException(message);
            }
        }
    }

    public void removePoint(Long pointRecordId, Long pointId) {
        PointRecord pointRecord = this.findById(pointRecordId);
        Iterator<UserAttendance> userAttendanceIterator = pointRecord.getUsersAttendances().iterator();

        while (userAttendanceIterator.hasNext()) {
            UserAttendance userAttendance = userAttendanceIterator.next();

            boolean removed = userAttendance.getAttendanceRecords()
                    .removeIf(attendanceRecord -> attendanceRecord.getPoint().getId().equals(pointId));

            if (removed && userAttendance.getAttendanceRecords().isEmpty()) {
                userAttendanceIterator.remove();
            }

            if (userAttendance.getAttendanceRecords().isEmpty()) {
                pointRecord.getUsersAttendances().remove(userAttendance);
            }
        }

        pointRecord.getPoints().removeIf(point -> point.getId().equals(pointId));
        this.update(pointRecord);
    }

    public void addPoint(Long pointRecordId, Point point) {
        PointRecord pointRecord = this.findById(pointRecordId);
        List<Point> points = pointRecord.getPoints();
        // Ordena a lista de pontos pela data final de forma ascendente
        points.sort(Comparator.comparing(Point::getFinalDate, Comparator.nullsFirst(LocalDateTime::compareTo)));
        Point lastPoint = points.get(points.size() - 1);
        validatePoint(pointRecord, point, lastPoint.getFinalDate());
        pointRecord.getPoints().add(point);

        pointRecord.getUsersAttendances().forEach(userAttendance -> {
            AttendanceRecord attendanceRecord = createAttendanceRecord(point);
            attendanceRecord.setUserAttendance(userAttendance);
            userAttendance.getAttendanceRecords().add(attendanceRecord);
        });

        this.update(pointRecord);
    }

    @Transactional
    public void deactivate(Long id) {
        PointRecord pointRecord = findById(id);
        pointRecord.setActive(false);
        update(pointRecord);
    }
}
