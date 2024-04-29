part of 'facial_factor_validate_bloc.dart';

@immutable
abstract class FacialFactorValidateState {}

class FacialFactorValidateInitial extends FacialFactorValidateState {}

class ValidateFaceLoading extends FacialFactorValidateState {}

class ValidateFaceSuccess extends FacialFactorValidateState {}

class ValidateFaceError extends FacialFactorValidateState {
  final String message;

  ValidateFaceError({required this.message});
}

class PhotoCapturedSuccess extends FacialFactorValidateState {
  final File image;

  PhotoCapturedSuccess({required this.image});
}
