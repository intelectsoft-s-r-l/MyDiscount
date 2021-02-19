part of 'profile_form_bloc.dart';

abstract class ProfileFormEvent extends Equatable {
  const ProfileFormEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends ProfileFormEvent {
  final String firstName;
  final bool isSubmitted;

  FirstNameChanged(this.firstName, this.isSubmitted);
}

class LastNameChanged extends ProfileFormEvent {
  final String lastName;
  final bool isSubmitted;
  LastNameChanged(this.lastName, this.isSubmitted);
}

class EmailChanged extends ProfileFormEvent {
  final String email;
  final bool isSubmitted;
  EmailChanged(this.email, this.isSubmitted);
}

class PhoneChanged extends ProfileFormEvent {
  final String phone;
  final bool isSubmitted;
  PhoneChanged(this.phone, this.isSubmitted);
}

class ImageChanged extends ProfileFormEvent {
  final Uint8List bytes;
  final bool isSubmitted;
  ImageChanged(this.bytes, this.isSubmitted);
}
