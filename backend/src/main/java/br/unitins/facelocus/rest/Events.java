package br.unitins.facelocus.rest;

import io.quarkiverse.renarde.Controller;
import io.quarkus.qute.CheckedTemplate;
import io.quarkus.qute.TemplateInstance;
import jakarta.ws.rs.Path;

@Path("/events")
public class Events extends Controller {

    @CheckedTemplate
    static class Templates {
        public static native TemplateInstance index();
    }

    @Path("/")
    public TemplateInstance index() {
        return Templates.index();
    }
}
