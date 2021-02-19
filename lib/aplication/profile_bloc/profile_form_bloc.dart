import 'dart:async';
import 'dart:typed_data';

import 'package:MyDiscount/domain/entities/profile_model.dart';
import 'package:MyDiscount/infrastructure/local_repository_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'profile_form_event.dart';
part 'profile_form_state.dart';

@injectable
class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  ProfileFormBloc(this._localRepositoryImpl) : super(ProfileFormInitial(_localRepositoryImpl.getLocalClientInfo()));
  final LocalRepositoryImpl _localRepositoryImpl;
  @override
  Stream<ProfileFormState> mapEventToState(
    ProfileFormEvent event,
  ) async* {
    if (event is FirstNameChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();
      if (event.isSubmitted) {
        final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(firstName: event.firstName));
        yield ProfileFormDone(pr);
      }
    }
    if (event is LastNameChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();
      if (event.isSubmitted) {
        final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(lastName: event.lastName));
        yield ProfileFormDone(pr);
      }
    }
    if (event is EmailChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();
      if (event.isSubmitted) {
        final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(email: event.email));
        yield ProfileFormDone(pr);
      }
    }
    if (event is PhoneChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();
      if (event.isSubmitted) {
        final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(phone: event.phone));
        yield ProfileFormDone(pr);
      }
    }
    if (event is ImageChanged) {
      final Profile profile = _localRepositoryImpl.getLocalClientInfo();
      if (event.isSubmitted) {
        final pr = _localRepositoryImpl.saveLocalClientInfo(profile.copyWith(photo: event.bytes));
        yield ProfileFormDone(pr);
      }
    }
  }
}
