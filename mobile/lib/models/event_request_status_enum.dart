enum EventRequestStatus {
  pending,
  approved,
  rejected;

  static EventRequestStatus? parse(String factor) {
    switch (factor) {
      case 'PENDING':
        return EventRequestStatus.pending;
      case 'APPROVED':
        return EventRequestStatus.approved;
      case 'REJECTED':
        return EventRequestStatus.rejected;
    }
    return null;
  }
}
