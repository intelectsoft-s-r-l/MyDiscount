part of 'profile_form_bloc.dart';

abstract class ProfileFormState extends Equatable {
  const ProfileFormState(
    this.profile, this.isSaved,
  );
  final Profile profile;
  final bool isSaved;

  @override
  List<Object> get props => [profile];
}

class ProfileFormInitial extends ProfileFormState {
  ProfileFormInitial(Profile profile,bool isSaved) : super(profile,isSaved);
}

class ProfileFormDone extends ProfileFormState {
  ProfileFormDone(Profile profile,bool isSaved) : super(profile,isSaved);
}
class ProfileFormError extends ProfileFormState{
  ProfileFormError(Profile profile, bool isSaved) : super(profile, isSaved);
}