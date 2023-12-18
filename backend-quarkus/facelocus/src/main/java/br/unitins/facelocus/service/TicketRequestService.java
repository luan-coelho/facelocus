package br.unitins.facelocus.service;

import br.unitins.facelocus.model.TicketRequest;
import br.unitins.facelocus.repository.TicketRequestRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class TicketRequestService extends BaseService<TicketRequest, TicketRequestRepository> {
}
