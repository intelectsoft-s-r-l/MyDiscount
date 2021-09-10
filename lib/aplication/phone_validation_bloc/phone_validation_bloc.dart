import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/is_service_repository.dart';
import '../../domain/repositories/local_repository.dart';

part 'phone_validation_event.dart';
part 'phone_validation_state.dart';

@injectable
class PhoneValidationBloc
    extends Bloc<PhoneValidationEvent, PhoneValidationState> {
  PhoneValidationBloc(this._isServiceImpl, this._localRepositoryImpl)
      : super(PhoneValidationInitial(''));
  final IsService _isServiceImpl;
  final LocalRepository _localRepositoryImpl;
  String code = '';
  @override
  Stream<PhoneValidationState> mapEventToState(
    PhoneValidationEvent event,
  ) async* {
    if (event is GetValidationCode) {
      code = await _isServiceImpl.validatePhone(phone: event.phone);
      //print(code);
      yield WaitingUserInput(code);
    }
    if (event is UserInputCode) {
      final isValid = _localRepositoryImpl.smsCodeVerification(
          event.serverCode, event.userCode);
      if (isValid) {
        yield ValidCode(event.userCode);
      } else {
        yield InvalidCode(code);
      }
    }
  }
}
