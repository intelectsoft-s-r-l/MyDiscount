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
    if (event is FirstNameChanged) {
      final profile = _localRepositoryImpl.getLocalClientInfo();
      final newProfile = profile.copyWith(firstName: event.firstName);
      _localRepositoryImpl.saveClientInfoLocal(newProfile);
      yield ProfileFormDone(newProfile, false);
    }
    if (event is LastNameChanged) {
      final profile = _localRepositoryImpl.getLocalClientInfo();
      final pr = profile.copyWith(lastName: event.lastName);

      _localRepositoryImpl.saveClientInfoLocal(pr);
      yield ProfileFormDone(pr, false);
    }
    if (event is EmailChanged) {
      final profile = _localRepositoryImpl.getLocalClientInfo();

      final pr = profile.copyWith(email: event.email);
      _localRepositoryImpl.saveClientInfoLocal(pr);

      yield ProfileFormDone(pr, false);
    }
    if (event is PhoneChanged) {
      final profile = _localRepositoryImpl.getLocalClientInfo();

      final pr = profile.copyWith(phone: event.phone);
      _localRepositoryImpl.saveClientInfoLocal(pr);

      yield ProfileFormDone(pr, false);
    }
    if (event is ImageChanged) {
      final profile = _localRepositoryImpl.getLocalClientInfo();

      final pr = profile.copyWith(photo: event.bytes);
      _localRepositoryImpl.saveClientInfoLocal(pr);
      yield ProfileFormDone(pr, false);
    }
    if (event is UpdateProfileData) {
      final profile = _localRepositoryImpl.getLocalClientInfo();
      yield ProfileFormInitial(profile, false);
    }
    if (event is SaveProfileData) {
      try {
        final map =
            await _localRepositoryImpl.returnProfileMapDataAsMap(event.profile);
        _localRepositoryImpl.saveClientInfoLocal(event.profile);
        await _isServiceImpl.updateClientInfo(json: map);
        yield ProfileFormDone(event.profile, true);
      } catch (e) {
        final profile = _localRepositoryImpl.getLocalClientInfo();
        yield ProfileFormError(profile, false);
      }
    }
  }
}
