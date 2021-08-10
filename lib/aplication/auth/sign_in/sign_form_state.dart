part of 'sign_form_bloc.dart';

abstract class SignFormState extends Equatable {
  const SignFormState();

  @override
  List<Object> get props => [];
}

class SignFormInitial extends SignFormState {}

class SignFormDone extends SignFormState {
  final User user;

  const SignFormDone(this.user);
  @override
  List<Object> get props => [user];
}

class SignInFormPhone extends SignFormState {
  final String phone;

  SignInFormPhone(this.phone);
}

class SignInFormReseted extends SignFormState {}

class SignInNetError extends SignFormState {
  const SignInNetError();
}

class SignInError extends SignFormState {
  //final String message;
  const SignInError(/* this.message */);
}
