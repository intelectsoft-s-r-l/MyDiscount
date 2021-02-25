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
  ProfileFormBloc(this._localRepositoryImpl, this._isServiceImpl) : super(ProfileFormInitial(_localRepositoryImpl.getLocalClientInfo(), false));
  final LocalRepository _localRepositoryImpl;
  final IsService _isServiceImpl;
  @override
  Stream<ProfileFormState> mapEventToState(
    ProfileFormEvent event,
  ) async* {
    if (event is FirstNameChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();
      final newProfile = profile.copyWith(firstName: event.firstName);
      _localRepositoryImpl.saveLocalClientInfo(newProfile);
      yield ProfileFormDone(newProfile, false);
    }
    if (event is LastNameChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();

      final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(lastName: event.lastName));
      yield ProfileFormDone(pr, false);
    }
    if (event is EmailChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();

      final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(email: event.email));

      yield ProfileFormDone(pr, false);
    }
    if (event is PhoneChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();

      final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(phone: event.phone));

      yield ProfileFormDone(pr, false);
    }
    if (event is ImageChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();

      final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(photo: event.bytes));
      final map = _localRepositoryImpl.returnProfileMapDataAsMap(pr);
      _localRepositoryImpl.saveLocalClientInfo(pr);
      _isServiceImpl.updateClientInfo(json: map);
      yield ProfileFormDone(pr, false);
    }
    if (event is SaveProfileData) {
      final map = _localRepositoryImpl.returnProfileMapDataAsMap(event.profile);
      _localRepositoryImpl.saveLocalClientInfo(event.profile);
      _isServiceImpl.updateClientInfo(json: map);
      yield ProfileFormDone(event.profile, true);
    }
  }
}
