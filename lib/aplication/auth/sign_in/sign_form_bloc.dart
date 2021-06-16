import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../infrastructure/core/internet_connection_service.dart';

part 'sign_form_event.dart';
part 'sign_form_state.dart';

@injectable
class SignFormBloc extends Bloc<SignFormEvent, SignFormState> {
  SignFormBloc(
    this._authRepositoryImpl,
    this.network,
  ) : super(SignFormInitial());
  final AuthRepository _authRepositoryImpl;
  final NetworkConnection network;

  @override
  Stream<SignFormState> mapEventToState(
    SignFormEvent event,
  ) async* {
    try {
      if (event is SignInWithGoogle) {
        yield* mapUserToState(_authRepositoryImpl.authenticateWithGoogle());
      }
      if (event is SignInWithFacebook) {
        yield* mapUserToState(_authRepositoryImpl.authenticateWithFacebook());
      }
      if (event is SignInWithApple) {
        yield* mapUserToState(_authRepositoryImpl.authenticateWithApple());
      }
      if (event is SignOutEvent) {
        _authRepositoryImpl.logOut();
        yield SignFormInitial();
      }
    } catch (e) {
      yield const SignInError();
    }
  }

  Stream<SignFormState> mapUserToState(Future<User> authFunction) async* {
    if (await network.isConnected) {
      final user = await authFunction;
      if (!user.isEmpty) {
        yield SignFormDone(user);
      } else {
        throw Exception();
      }
    } else {
      yield const SignInNetError();
    }
  }
}
