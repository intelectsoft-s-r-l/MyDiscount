import 'dart:async';

import 'package:MyDiscount/infrastructure/is_service_impl.dart';
import 'package:MyDiscount/infrastructure/local_repository_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'phone_validation_event.dart';
part 'phone_validation_state.dart';

@injectable
class PhoneValidationBloc extends Bloc<PhoneValidationEvent, PhoneValidationState> {
  PhoneValidationBloc(this._isServiceImpl, this._localRepositoryImpl) : super(PhoneValidationInitial(null));
  final IsServiceImpl _isServiceImpl;
  final LocalRepositoryImpl _localRepositoryImpl;
  @override
  Stream<PhoneValidationState> mapEventToState(
    PhoneValidationEvent event,
  ) async* {
    if (event is GetValidationCode) {
      final String code = await _isServiceImpl.validatePhone(phone: event.phone);
      print(code);
      yield WaitingUserInput(code);
    }
    if (event is UserInputCode) {
      final bool isValid = _localRepositoryImpl.smsCodeVerification(event.serverCode, event.userCode);
      if (isValid) {
        yield ValidCode(event.userCode);
      } else {
        yield InvalidCode(event.userCode);
      }
    }
  }
}
