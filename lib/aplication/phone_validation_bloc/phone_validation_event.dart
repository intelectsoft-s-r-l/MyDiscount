part of 'phone_validation_bloc.dart';

abstract class PhoneValidationEvent extends Equatable {
  const PhoneValidationEvent();

  @override
  List<Object> get props => [];
}

class GetValidationCode extends PhoneValidationEvent {
  final String phone;

  GetValidationCode(this.phone);
}

class UserInputCode extends PhoneValidationEvent {
  final String userCode;
  final String serverCode;

  UserInputCode(this.userCode,this.serverCode);
}
