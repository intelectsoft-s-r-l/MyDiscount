import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/profile_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../domain/repositories/local_repository.dart';

part 'profile_form_event.dart';
part 'profile_form_state.dart';

@injectable
class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  ProfileFormBloc(this._localRepositoryImpl, this._isServiceImpl)
      : super(ProfileFormInitial(
            _localRepositoryImpl.getLocalClientInfo(), false));
  final LocalRepository _localRepositoryImpl;
  final IsService _isServiceImpl;
  @override
  Stream<ProfileFormState> mapEventToState(
    ProfileFormEvent event,
  ) async* {
    final profile = _localRepositoryImpl.getLocalClientInfo();
    if (event is FirstNameChanged) {
      final newProfile = profile.copyWith(firstName: event.firstName);
      yield* mapProfileToState(newProfile);
    }
    if (event is LastNameChanged) {
      final newProfile = profile.copyWith(lastName: event.lastName);
      yield* mapProfileToState(newProfile);
    }
    if (event is EmailChanged) {
      final newProfile = profile.copyWith(email: event.email);
      yield* mapProfileToState(newProfile);
    }
    if (event is PhoneChanged) {
      final newProfile = profile.copyWith(phone: event.phone);
      yield* mapProfileToState(newProfile);
    }
    if (event is ImageChanged) {
      final newProfile = profile.copyWith(photo: event.bytes);
      yield* mapProfileToState(newProfile);
    }
    if (event is UpdateProfileData) {
      final profile = _localRepositoryImpl.getLocalClientInfo();
      yield ProfileFormInitial(profile, false);
    }
    if (event is SaveProfileData) {
      try {
        final map =
            await _localRepositoryImpl.returnProfileDataAsMap(event.profile);
        await _isServiceImpl.updateClientInfo(json: map);
        yield* mapProfileToState(event.profile);
      } catch (e) {
        final profile = _localRepositoryImpl.getLocalClientInfo();
        yield ProfileFormError(profile, false);
      }
    }
    if (event is UpdateProfileData) {
      final profile = _localRepositoryImpl.getLocalClientInfo();
      yield ProfileFormDone(profile, true);
    }
  }

  Stream<ProfileFormState> mapProfileToState(Profile profile) async* {
    _localRepositoryImpl.saveClientInfoLocal(profile);
    yield ProfileFormDone(profile, false);
  }
}
