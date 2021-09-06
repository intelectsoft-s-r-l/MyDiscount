part of 'sign_form_bloc.dart';

abstract class SignFormEvent extends Equatable {
  const SignFormEvent();

  @override
  List<Object> get props => [];
}

class SignInWithPhone extends SignFormEvent {
  final String phone;

  SignInWithPhone(this.phone);
}

class PhoneChecked extends SignFormEvent {
  final String phone;

  PhoneChecked(this.phone);
}

class ResetState extends SignFormEvent {}

class SignInWithGoogle extends SignFormEvent {}

class SignInWithFacebook extends SignFormEvent {}

class SignInWithApple extends SignFormEvent {}

class SignOutEvent extends SignFormEvent {}
