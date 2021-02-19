part of 'profile_form_bloc.dart';

abstract class ProfileFormState extends Equatable {
  const ProfileFormState(
    this.profile,
  );
  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class ProfileFormInitial extends ProfileFormState {
  ProfileFormInitial(Profile profile) : super(profile);
}

class ProfileFormDone extends ProfileFormState {
  ProfileFormDone(
    Profile profile
  ) : super(profile);
}
