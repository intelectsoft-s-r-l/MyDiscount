part of 'profile_form_bloc.dart';

abstract class ProfileFormEvent extends Equatable {
  const ProfileFormEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends ProfileFormEvent {
  final String firstName;

  FirstNameChanged(
    this.firstName,
  );
}

class LastNameChanged extends ProfileFormEvent {
  final String lastName;

  LastNameChanged(
    this.lastName,
  );
}

class EmailChanged extends ProfileFormEvent {
  final String email;

  EmailChanged(
    this.email,
  );
}

class PhoneChanged extends ProfileFormEvent {
  final String phone;

  PhoneChanged(
    this.phone,
  );
}

class ImageChanged extends ProfileFormEvent {
  final Uint8List bytes;

  ImageChanged(
    this.bytes,
  );
}

class SaveProfileData extends ProfileFormEvent {
 final Profile profile;

  SaveProfileData(this.profile);
}
