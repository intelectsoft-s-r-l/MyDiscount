part of 'sign_form_bloc.dart';

abstract class SignFormEvent extends Equatable {
  const SignFormEvent();

  @override
  List<Object> get props => [];
}

class SignInWithGoogle extends SignFormEvent {}

class SignInWithFacebook extends SignFormEvent {}

class SignInWithApple extends SignFormEvent {}
class SignOutEvent extends SignFormEvent{}