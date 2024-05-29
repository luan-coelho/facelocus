package br.unitins.facelocus.resource;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/*
@Path("/time")
public class TimeResource {

    @GET
    public String getCurrentTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        ZoneId zone = ZoneId.systemDefault();  // Pega o timezone atual do sistema
        String formattedDateTime = LocalDateTime.now().format(formatter);
        return formattedDateTime + " TimeZone: " + zone.toString();
    }
}*/
