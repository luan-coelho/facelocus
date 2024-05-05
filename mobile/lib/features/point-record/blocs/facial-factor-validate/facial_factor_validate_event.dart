part of 'facial_factor_validate_bloc.dart';

@immutable
abstract class FacialFactorValidateEvent {}

class ValidateFace extends FacialFactorValidateEvent {
  final File image;
  final int attendanceRecordId;
  final int pointRecordId;

  ValidateFace({
    required this.image,
    required this.attendanceRecordId,
    required this.pointRecordId,
  });
}

class PhotoCaptured extends FacialFactorValidateEvent {
  final File image;

  PhotoCaptured({
    required this.image,
  });
}

class ResetCapture extends FacialFactorValidateEvent {}
