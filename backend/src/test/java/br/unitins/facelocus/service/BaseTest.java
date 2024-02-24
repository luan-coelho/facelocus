package br.unitins.facelocus.service;

import br.unitins.facelocus.model.*;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import org.eclipse.microprofile.config.ConfigProvider;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.fail;

public abstract class BaseTest {

    protected static final String USER_HOME = ConfigProvider.getConfig().getValue("files.users.facephoto.basepath",
            String.class);
    protected static final String RESOURCES_DIRECTORY = ConfigProvider.getConfig()
            .getValue("files.users.facephoto.resources", String.class);
    protected static final String SEPARATOR = File.separator; // "\" ou "/"

    protected User user1;
    protected User user2;
    protected Event event1;
    protected Event event2;
    protected LocalDate today;
    protected LocalDateTime now;

    @Inject
    EntityManager em;

    @Transactional
    protected User getUser() {
        User user = new User();
        user.setName("Joao");
        user.setSurname("Silva");
        user.setCpf("01534043020");
        user.setEmail("joao@gmail.com");
        user.setPassword("12345");
        em.persist(user);
        return user;
    }

    @Transactional
    protected Event getEvent() {
        Location location1 = getLocation();
        Location location2 = getLocation();

        Event event = new Event();
        event.setDescription("Evento " + new Random().nextInt(1000));
        event.setCode("ABC123");
        event.setAdministrator(user1);
        event.setUsers(new ArrayList<>(List.of(user2)));
        location1.setEvent(event);
        location2.setEvent(event);
        event.setLocations(new ArrayList<>(List.of(location1, location2)));
        em.merge(event);
        return event;
    }

    @Transactional
    protected Location getLocation() {
        return new Location(null, "Minha Casa", "123456", "654321", null);
    }

    protected PointRecord getPointRecord() {
        PointRecord pointRecord = new PointRecord();
        pointRecord.setEvent(event1);
        pointRecord.setDate(today);
        pointRecord.setFactors(new HashSet<>(Set.of(Factor.FACIAL_RECOGNITION, Factor.INDOOR_LOCATION)));
        pointRecord.setLocation(event1.getLocations().get(0));
        pointRecord.setAllowableRadiusInMeters(5d);
        pointRecord.setInProgress(false);
        Point point1 = new Point(
                null,
                now,
                now.plusMinutes(10),
                pointRecord);
        Point point2 = new Point(
                null,
                now.plusMinutes(20),
                now.plusMinutes(30),
                pointRecord);
        Point point3 = new Point(
                null,
                now.plusMinutes(40),
                now.plusMinutes(50),
                pointRecord);
        pointRecord.setPoints(new ArrayList<>(List.of(point1, point2, point3)));
        return pointRecord;
    }

    InputStream getImageAsInputStream(String imageName) {
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

    static void removeImageFolder(String path) {
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
