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

  static String toJson(EventRequestType requestType) {
    switch (requestType) {
      case EventRequestType.ticketRequest:
        return 'TICKET_REQUEST';
      case EventRequestType.invitation:
        return 'INVITATION';
    }
  }
}
