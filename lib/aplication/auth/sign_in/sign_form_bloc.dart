import 'dart:async';

import 'package:MyDiscount/domain/entities/user_model.dart';
import 'package:MyDiscount/infrastructure/auth_repository_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'sign_form_event.dart';
part 'sign_form_state.dart';

@injectable
class SignFormBloc extends Bloc<SignFormEvent, SignFormState> {
  SignFormBloc(
    this._authRepositoryImpl,
  ) : super(SignFormInitial());
  final AuthRepositoryImpl _authRepositoryImpl;

  @override
  Stream<SignFormState> mapEventToState(
    SignFormEvent event,
  ) async* {
    if (event is SignInWithGoogle) {
      final user = await _authRepositoryImpl.authenticateWithGoogle();
      if (user != null) {
        yield SignFormDone(user);
      }
    }
    if (event is SignInWithFacebook) {
      final user = await _authRepositoryImpl.authenticateWithFacebook();
      if (user != null) {
        yield SignFormDone(user);
      }
    }
    if (event is SignInWithApple) {
      final user = await _authRepositoryImpl.authenticateWithApple();
      if (user != null) {
        yield SignFormDone(user);
      }
    }
    if (event is SignOutEvent) {
      _authRepositoryImpl.logOut();
      yield SignFormInitial();
    }
  }
}
