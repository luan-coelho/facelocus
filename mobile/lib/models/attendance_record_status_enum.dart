enum AttendanceRecordStatus {
  validated,
  notValidated,
  pending;

  static AttendanceRecordStatus? parse(String factor) {
    switch (factor) {
      case 'VALIDATED':
        return AttendanceRecordStatus.validated;
      case 'NOT_VALIDATED':
        return AttendanceRecordStatus.notValidated;
      case 'PENDING':
        return AttendanceRecordStatus.pending;
    }
    return null;
  }
}
