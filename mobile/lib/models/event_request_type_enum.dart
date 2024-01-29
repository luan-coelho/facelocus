enum EventRequestType {
  ticketRequest,
  invitation;

  static EventRequestType? parse(String factor) {
    switch (factor) {
      case 'TICKET_REQUEST':
        return EventRequestType.ticketRequest;
      case 'INVITATION':
        return EventRequestType.invitation;
    }
    return null;
  }
}
