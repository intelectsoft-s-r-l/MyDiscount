part of 'sign_form_bloc.dart';

abstract class SignFormState extends Equatable {
  const SignFormState();

  @override
  List<Object> get props => [];
}

class SignFormInitial extends SignFormState {}

class SignFormDone extends SignFormState {
  final User user;

  SignFormDone(this.user);
  @override
  List<Object> get props => [user];
}
