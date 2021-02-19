part of 'phone_validation_bloc.dart';

abstract class PhoneValidationState extends Equatable {
  const PhoneValidationState(this.serverCode);
  final String serverCode;
  @override
  List<Object> get props => [];
}

class PhoneValidationInitial extends PhoneValidationState {
  PhoneValidationInitial(String serverCode) : super(serverCode);
}

class WaitingUserInput extends PhoneValidationState {
  WaitingUserInput(String serverCode) : super(serverCode);
}

class ValidCode extends PhoneValidationState {
  ValidCode(String serverCode) : super(serverCode);
}

class InvalidCode extends PhoneValidationState {
  InvalidCode(String serverCode) : super(serverCode);
}
